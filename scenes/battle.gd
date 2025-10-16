extends Node2D
var initial_charpos = Vector2(360,240)
var initial_enemypos = Vector2(920,240)
var char_scene = load("res://scenes/battler.tscn")
var enemy_scene = load("res://scenes/enemy_battler.tscn")

@onready var battlers = $Battlers
@onready var enemy_battlers = $EnemyBattlers

var waves:Array[Wave] = State.loaded_encounter.waves
var current_wave = 0

signal enemy_turn_done
var enemy_turn_started = false
var post_turn_ran = false
var all_enemies_down:bool = false
var all_battlers_down = false

var ongoing_enemy_turn = false
var waiting_for_last_action = false

func load_wave(wave:Wave):
	initial_enemypos = Vector2(920,(-64 * (wave.enemy_array.size() - 1)) + 256)
	var enemy_separation = 0
	for e in wave.enemy_array:
		var enemy:EnemyBattler = enemy_scene.instantiate()
		enemy.enemy_data = e.duplicate()
		enemy.position = initial_enemypos + Vector2(enemy_separation * -32,enemy_separation * -128)
		enemy_separation -= 1
		enemy_battlers.add_child(enemy)
	
	
func _ready() -> void:
	State.set_mana(0)
	State.turn_counter = 0
	BattleUI.set_battle_comment(State.loaded_encounter.get_entry_comment())
	var separation = 0
	initial_charpos = Vector2(360,(-64 * (State.loaded_encounter.party.size() - 1)) + 256)
	for c in State.loaded_encounter.party:
		var ch:Battler = char_scene.instantiate()
		ch.char_data = c.duplicate()
		ch.char_data.skill_changes_resource.apply_changed_skills(ch)
		ch.position = initial_charpos + Vector2(separation * 32,separation * -128)
		separation -= 1
		battlers.add_child(ch)
	for battler:Battler in battlers.get_children():
		print(battler.char_data.display_name)
		for charm in State.attached_charms.get(battler.char_data.id):
			charm[1].on_battle_start_effects(battler)
	waves = State.loaded_encounter.waves
	BattleUI.initialize_healthbars(battlers.get_children())

func _process(_delta: float) -> void:
	while current_wave < waves.size() and enemy_battlers.get_child_count() == 0:
		load_wave(waves[current_wave])
		current_wave += 1
	State.set_battler_arrays(battlers.get_children(),enemy_battlers.get_children())
	if not ongoing_enemy_turn:
		check_all_turns_done()
	pass

func turn_manager():
	if ongoing_enemy_turn: return
	ongoing_enemy_turn = true
	enemy_turn()
	print("Reached end of enemy turn.")
	await enemy_turn_done
	post_turn()
	print("Reached end of post-turn.")
	for b:Battler in battlers.get_children():
		if b.health > 0:
			b.weak_state = false
			b.turn_status(false)
		else:
			b.turn_status(true)
			print("sssssssssssskipped turn of %s" % b.char_data.display_name)
	var campsite:PackedScene = load("res://scenes/campsite.tscn")
	if all_enemies_down:
		if current_wave >= waves.size():
			if not State.levels_beaten[State.current_level_position] and State.loaded_encounter.completion_reward.charm_ID != ID.CharmID.None:
				var charmtionary:Dictionary
				charmtionary[State.loaded_encounter.completion_reward] = true
				State.unlocked_charms[State.loaded_encounter.completion_reward.charm_ID] = charmtionary
				State.max_level_reached += 1
			State.levels_beaten[State.current_level_position] = true
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_packed(campsite)
	if all_battlers_down and not all_enemies_down:
		BattleUI.set_battle_comment("Everyone was defeated!")
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_packed(campsite)
		
	State.finish_action()
	ongoing_enemy_turn = false

func check_all_turns_done():
	for b in battlers.get_children():
		if not b.turn_done and b.health > 0:
			return
	if not waiting_for_last_action:
		print("Waiting for last action from Archangel Hunters to complete.")
		print("If this prints more than once something fucked up.")
		waiting_for_last_action = true
		await State.someone_finished_something
		waiting_for_last_action = false
		turn_manager()

func enemy_turn():
	await get_tree().create_timer(1).timeout
	BattleUI.set_battle_comment("The opponents strike!")
	for e in enemy_battlers.get_children():
		if check_all_battlers_down():
			break
			
		var skip_turn = false
		for status in e.status_array:
			if status != null and status.is_stun:
				skip_turn = true
				State.finish_action()
		if e.health <= 0:
			skip_turn = true
		if skip_turn:
			continue
		
		e.enemy_data.do_attack(e)
		await State.someone_finished_something
		await get_tree().create_timer(0.4).timeout
	await get_tree().create_timer(1).timeout
	enemy_turn_started = false
	enemy_turn_done.emit()

func post_turn():
	all_battlers_down = true
	for battler:Battler in battlers.get_children():
		print(battler.char_data.display_name)
		for charm in State.attached_charms.get(battler.char_data.id):
			charm[1].post_turn_effects(battler)
		for status in battler.status_array:
			if status == null: continue
			status.onTickDown(battler)
			status.tickDown()
			if status.turns_left <= 0:
				status.onExpire(battler)
				battler.status_array[status.status_ID] = null
		if battler.health <= 0:
			battler.heal((battler.char_data.max_hp / 2) * 0.2,battler)
		else:
			all_battlers_down = false
	all_enemies_down = true
	for enemy in enemy_battlers.get_children():
		for status in enemy.status_array:
			if status == null: continue
			status.onTickDown_enemy(enemy)
			status.tickDown()
			if status.turns_left <= 0:
				status.onExpire_enemy(enemy)
				enemy.status_array[status.status_ID] = null
		if enemy.health > 0:
			all_enemies_down = false
		else:
			enemy.vanquish()
	
	State.turn_counter += 1
	print("Turn: %s" % State.turn_counter)
	for battler:Battler in battlers.get_children():
		print(battler.char_data.display_name)
		for charm in State.attached_charms.get(battler.char_data.id):
			charm[1].post_turn_effects(battler)
	var battle_text = State.loaded_encounter.get_comment() if not all_enemies_down else ("Battle won!" if current_wave >= waves.size() else "Wave Complete!")
	BattleUI.set_battle_comment(battle_text)

##Also updates [all_battlers_down].
func check_all_battlers_down():
	all_battlers_down = true
	for battler in battlers.get_children():
		if battler.health > 0:
			all_battlers_down = false
	return all_battlers_down
