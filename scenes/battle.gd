extends Node2D
var encounter:Encounter = load("res://stats/Encounters/VariousGuys.tres")
var initial_charpos = Vector2(360,240)
var initial_enemypos = Vector2(920,240)
var char_scene = load("res://scenes/battler.tscn")
var enemy_scene = load("res://scenes/enemy_battler.tscn")

@onready var battlers = $Battlers
@onready var enemy_battlers = $EnemyBattlers

signal enemy_turn_done
var enemy_turn_started = false
var post_turn_ran = false

func _ready() -> void:
	State.turn_counter = 0
	BattleUI.set_battle_comment(encounter.default_battle_comments.pick_random())
	var separation = 0
	initial_charpos = Vector2(360,(-64 * (State.current_party.size() - 1)) + 256)
	initial_enemypos = Vector2(920,(-64 * (encounter.enemy_array.size() - 1)) + 256)
	for c in State.current_party:
		var ch:Battler = char_scene.instantiate()
		ch.char_data = c.duplicate()
		ch.position = initial_charpos + Vector2(separation * 32,separation * -128)
		separation -= 1
		battlers.add_child(ch)
	var enemy_separation = 0
	for e in encounter.enemy_array:
		var enemy:EnemyBattler = enemy_scene.instantiate()
		enemy.enemy_data = e.duplicate()
		enemy.position = initial_enemypos + Vector2(enemy_separation * -32,enemy_separation * -128)
		enemy_separation -= 1
		enemy_battlers.add_child(enemy)
	BattleUI.initialize_healthbars(battlers.get_children())

var ongoing_enemy_turn = false
func _process(_delta: float) -> void:
	State.set_battler_arrays(battlers.get_children(),enemy_battlers.get_children())
	if not ongoing_enemy_turn:
		check_all_turns_done()
	pass

func turn_manager():
	ongoing_enemy_turn = true
	if not enemy_turn_started:
		enemy_turn_started = true
		enemy_turn()
	await enemy_turn_done
	post_turn()
	for b:Battler in battlers.get_children():
		if b.health > 0:
			b.weak_state = false
			b.turn_status(false)
		else:
			b.turn_status(true)
	
	State.finish_action()
	ongoing_enemy_turn = false

func check_all_turns_done():
	for b in battlers.get_children():
		if not b.turn_done and b.health > 0:
			return
	turn_manager()

func enemy_turn():
	await get_tree().create_timer(1.75).timeout
	BattleUI.set_battle_comment("The opponents strike!")
	for e in enemy_battlers.get_children():
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
	for battler in battlers.get_children():
		print(battler.char_data.display_name)
		for status in battler.status_array:
			if status == null: continue
			status.onTickDown(battler)
			status.tickDown()
			if status.turns_left <= 0:
				status.onExpire(battler)
				battler.status_array[status.status_ID] = null
		if battler.health <= 0:
			battler.heal((battler.char_data.max_hp / 2) * 0.2)
	var all_enemies_down:bool = true
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
	var battle_text = encounter.default_battle_comments.pick_random() if not all_enemies_down else "Battle won!"
	BattleUI.set_battle_comment(battle_text)
