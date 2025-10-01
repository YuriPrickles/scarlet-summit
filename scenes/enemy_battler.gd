class_name EnemyBattler
extends Node2D
var enemy_data:Enemy
@onready var hpbar:ProgressBar = $HPBar
@onready var delay_counter:RichTextLabel = $DelayCounter
@onready var tauntline:Line2D = $Tauntline

var health
var max_health

var tiredness
var tired_threshold

var defense
var attack

var turn_delay
var og_position:Vector2
var locked_target:Battler = null

signal finished_action

var status_array:Array[StatusEffect]

func _ready() -> void:
	health = enemy_data.hp
	max_health = enemy_data.max_hp
	tiredness = 0
	tired_threshold = enemy_data.tired_threshold
	defense = enemy_data.defense
	attack = enemy_data.attack
	hpbar.max_value = enemy_data.max_hp
	hpbar.value = enemy_data.hp
	og_position = position
	status_array.resize(999)

func _process(_delta: float) -> void:
	tauntline.visible = !State.someone_doing_something
	if locked_target != null && tauntline.points.size() == 0:
		var tl_pointarray:PackedVector2Array = [locked_target.global_position + Vector2(0,64),global_position + Vector2(0,64)]
		tauntline.points = tl_pointarray
		tauntline.global_position = Vector2(0,0)
	if locked_target == null && tauntline.points.size() != 0:
		tauntline.clear_points()
	turn_delay = enemy_data.turn_delay
	delay_counter.text = "[font_size=32]%s" % turn_delay if turn_delay != 0 else ""
	pass
func update_hp(bar:ProgressBar, new_value):
	bar.value = new_value

func heal(amount:int):
	health = min(health + amount,max_health)
	update_hp(hpbar,health)
	State.popatext(self, amount, Color.LIGHT_GREEN)

func hurt(damage:int,attacker:Battler=null,allow_onhit=true):
	print("%s hurt for %s damage" % [enemy_data.display_name, damage])
	
	if attacker != null and allow_onhit:
		enemy_data.on_hit(self,attacker,damage)
	
	health -= damage
	update_hp(hpbar,health)
	

	State.popatext(self,damage,Color.WHITE)

func vanquish():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",position + Vector2(600,0), 1.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(queue_free)
enum AttackAnimations{
	GetClose,
	StayInPlace,
	GoToMiddle,
	Filler
}

func get_target(set_lock=false) -> Battler:
	if not set_lock:
		if locked_target != null:
			return locked_target
	var battlers = State.battler_array
	var chosen_battler:Battler = battlers.pick_random()
	chosen_battler = battlers.pick_random()
	while chosen_battler.health <= 0 and not set_lock:
		chosen_battler = battlers.pick_random()
	while locked_target == chosen_battler and set_lock and chosen_battler.health <= 0:
		chosen_battler = battlers.pick_random()
	#if chosen_battler.char_data.id == ID.CharID.GoldenSun:
		#for battler in State.battler_array:
			#if battler.has_status(ID.StatusID.Sunblock):
				#battler.hurt(damage_against(battler),self)
				#print("blocked by a teammate!")
				#await get_tree().create_timer(0.6).timeout
				#chosen_battler.cast_skill(chosen_battler.char_data.basic_atk,self)
				#return
	return chosen_battler

func lock_target(target:Battler):
	locked_target = target

func unlock_target():
	locked_target = null

func attack_enemy(target:Battler,attack_anim:AttackAnimations,attack_method:Callable,return_after:float=0.6):
	State.someone_doing_something = true
	match attack_anim:
		AttackAnimations.GetClose:
			move_to(target.position + Vector2(150,0),0.4)
			await get_tree().create_timer(0.6).timeout
			attack_method.call()
			await get_tree().create_timer(return_after).timeout
			await get_tree().create_timer(return_to_place()).timeout
		AttackAnimations.StayInPlace:
			await get_tree().create_timer(0.6).timeout
			attack_method.call()
			await get_tree().create_timer(return_after).timeout
			await get_tree().create_timer(return_to_place()).timeout
		AttackAnimations.GoToMiddle:
			move_to(Vector2(640, 360),0.4)
			await get_tree().create_timer(0.6).timeout
			attack_method.call()
			await get_tree().create_timer(return_after).timeout
			await get_tree().create_timer(return_to_place()).timeout
		AttackAnimations.Filler:
			await get_tree().create_timer(0.6).timeout
	State.finish_action()

#To not cause loops with on-hurt abilities
func attack_reflect(target:Battler,mult:float=1):
	target.hurt(damage_against(target) * mult,self)

func attack_one(target:Battler,mult:float = 1):
	if target.char_data.id == ID.CharID.GoldenSun:
		for battler in State.battler_array:
			if battler.has_status(ID.StatusID.Sunblock):
				battler.hurt(damage_against(battler) * mult,self)
				print("blocked by a teammate!")
				target.stored_hits += 1
				return
	target.hurt(damage_against(target) * mult,self)
		
func attack_all(mult:float = 1):
	for b in State.battler_array:
		b.hurt(damage_against(b) * mult,self)

func attack_wildhits(hits:int, mult:float = 1):
	var all_down = true
	for i in range(hits):
		var b:Battler = State.battler_array.pick_random()
		while b.health <= 0:
			for bat in State.battler_array:
				if bat.health > 0:
					all_down = false
			if all_down: break
			b = State.battler_array.pick_random()
		var donthurt = false
		if b.char_data.id == ID.CharID.GoldenSun:
			for battler in State.battler_array:
				if battler.has_status(ID.StatusID.Sunblock):
					battler.hurt(damage_against(battler) * mult,self)
					print("blocked by a teammate!")
					b.stored_hits += 1
					donthurt = true
				if battler.has_status(ID.StatusID.Flowerfence):
					battler.hurt(damage_against(battler) * mult,self)
					print("blocked by a teammate!")
					donthurt = true
		if not donthurt:
			b.hurt(damage_against(b) * mult,self)
		await get_tree().create_timer(0.1).timeout

func move_to(target:Vector2,duration:float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func return_to_place(duration:float = 0.3):
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "position", og_position, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.tween_callback(emit_signal.bind("finished_action"))
	return duration
	
func add_status(status:Array[StatusEffect],turns:Array[int]):
	if status.size() != turns.size():
		print("Error with applying statuses.")
		return
	for i in status.size():
		if turns[i] <= 0: return
		status[i].turns_left = turns[i]
		status_array[status[i].status_ID] = status[i].duplicate()
		var color = Color.MEDIUM_PURPLE if status[i].is_bad else Color.LIGHT_GREEN
		State.popatext(self,status[i].buff_name,color)
	pass

func get_def_mult() -> float:
	var total_mult = 1
	for status in status_array:
		if status == null: continue
		if status.def_mult != 0:
			total_mult += status.def_mult
	total_mult += defense * 0.02
	return total_mult
	
func get_atk_mult() -> float:
	var total_mult = 1
	for status in status_array:
		if status == null: continue
		if status.atk_mult != 0:
			total_mult += status.atk_mult
	return total_mult

func damage_against(target:Battler) -> int:
	return roundi(State.damage_calc(attack,get_atk_mult(),target.get_def_mult()))

func has_status(status_ID:ID.StatusID) -> bool:
	return status_array[status_ID] != null

func add_tired(amount:int):
	tiredness += amount
	if tiredness >= tired_threshold:
		enemy_data.on_sleep(self)
		add_status(
			[load("res://stats/Statuses/Tired.tres"),
			load("res://stats/Statuses/Asleep.tres")],
			[4,1])
		tiredness = 0

func summon_enemy(e:Enemy,position:Vector2):
	var enemy_scene = load("res://scenes/enemy_battler.tscn")
	var enemy:EnemyBattler = enemy_scene.instantiate()
	enemy.enemy_data = e.duplicate()
	enemy.position = position
	State.get_enemy_battlers_node().add_child(enemy)

var is_hovering = false
var hover_display_req_sent = false
func _on_hover_area_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if State.someone_doing_something: return
	if Input.is_action_pressed("dragging") and not is_hovering:
		EnemyHoverInfo.hide()
		hover_display_req_sent = false
		return
	if not hover_display_req_sent:
		hover_display_req_sent = true
	else:
		return
	await get_tree().create_timer(1).timeout
	if (not Input.is_action_pressed("dragging") and is_hovering):
		EnemyHoverInfo.status_array = status_array.duplicate()
		var tired_percent = ((float(tiredness)/float(tired_threshold)) * 100)
		var tired_count = "%d/%d Tiredness" % [tiredness,tired_threshold]
		EnemyHoverInfo.EnemyName.text = "[font_size=32]%s   [color=light_gray][font_size=16][%s | %d%% Tired]" % [enemy_data.display_name, tired_count, tired_percent]
		EnemyHoverInfo.EnemyName2.text = "[font_size=32]%s   [color=light_gray][font_size=16][%s | %d%% Tired]" % [enemy_data.display_name, tired_count, tired_percent]
		
		EnemyHoverInfo.AttackInfo.text = "[font_size=16]%s" % enemy_data.attack_desc
		EnemyHoverInfo.show()
	pass # Replace with function body.

func _on_hover_area_mouse_exited() -> void:
	is_hovering = false
	hover_display_req_sent = false
	EnemyHoverInfo.hide()
	pass # Replace with function body.


func _on_hover_area_mouse_entered() -> void:
	is_hovering = true
	pass # Replace with function body.
