class_name EnemyBattler
extends Node2D
var enemy_data:Enemy
@onready var hpbar:ProgressBar = $HPBar
@onready var delay_counter:RichTextLabel = $DelayCounter

var health
var max_health
var defense
var attack
var turn_delay
var og_position:Vector2

signal finished_action

@export var status_array:Array[StatusEffect]

func _ready() -> void:
	health = enemy_data.hp
	max_health = enemy_data.max_hp
	defense = enemy_data.defense
	attack = enemy_data.attack
	hpbar.max_value = enemy_data.max_hp
	hpbar.value = enemy_data.hp
	og_position = position
	status_array.resize(999)

func _process(_delta: float) -> void:
	turn_delay = enemy_data.turn_delay
	delay_counter.text = "[font_size=32]%s" % turn_delay if turn_delay != 0 else ""
	pass
func update_hp(bar:ProgressBar, new_value):
	bar.value = new_value
func hurt(damage:int,attacker:Battler=null):
	print("%s hurt for %s damage" % [enemy_data.display_name, damage])
	if attacker != null:
		enemy_data.on_hit(self,attacker)
	health -= damage
	update_hp(hpbar,health)
	var poptext:PopupText = preload("res://scenes/pop_up_text.tscn").instantiate()
	poptext.ptext = damage
	poptext.global_position = global_position + Vector2(randi_range(-16,16),randi_range(-16,16))
	add_child(poptext)

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
func attack_enemy(target:Battler,attack_anim:AttackAnimations,attack_method:Callable,return_after:float=0.6):
	State.someone_doing_something = true
	match attack_anim:
		AttackAnimations.GetClose:
			move_to(target.position + Vector2(150,0),0.4)
			await get_tree().create_timer(0.6).timeout
			attack_method.call()
			await get_tree().create_timer(return_after).timeout
			return_to_place()
		AttackAnimations.StayInPlace:
			await get_tree().create_timer(0.6).timeout
			attack_method.call()
			await get_tree().create_timer(return_after).timeout
			return_to_place()
		AttackAnimations.GoToMiddle:
			move_to(Vector2(640, 360),0.4)
			await get_tree().create_timer(0.6).timeout
			attack_method.call()
			await get_tree().create_timer(return_after).timeout
			return_to_place()
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
				battler.hurt(damage_against(battler),self)
				print("blocked by a teammate!")
				await get_tree().create_timer(0.6).timeout
				target.cast_skill(target.char_data.basic_atk,self)
				return
	target.hurt(damage_against(target) * mult,self)
		
func attack_all(mult:float = 1):
	for b in State.battler_array:
		b.hurt(damage_against(b) * mult,self)

func attack_wildhits(hits:int, mult:float = 1):
	for i in range(hits):
		var b = State.battler_array.pick_random()
		while b.health <= 0:
			b = State.battler_array.pick_random()
		if b.char_data.id == ID.CharID.GoldenSun:
			for battler in State.battler_array:
				if battler.has_status(ID.StatusID.Sunblock):
					battler.hurt(damage_against(battler),self)
					print("blocked by a teammate!")
					await get_tree().create_timer(0.6).timeout
					b.cast_skill(b.char_data.basic_atk,self)
					return
		b.hurt(damage_against(b) * mult,self)
		await get_tree().create_timer(0.2).timeout

func move_to(target:Vector2,duration:float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func return_to_place(duration:float = 0.3):
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "position", og_position, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.tween_callback(emit_signal.bind("finished_action"))
	
func add_status(status:StatusEffect,turns:int):
	status.turns_left = turns
	status_array[status.status_ID] = status.duplicate()
	var poptext:PopupText = preload("res://scenes/pop_up_text.tscn").instantiate()
	var color:String = "medium_purple" if status.is_bad else "light_green"
	poptext.ptext = "[color=%s]%s"%[color,status.buff_name]
	poptext.global_position = global_position + Vector2(randi_range(-16,16),randi_range(-16,16))
	add_child(poptext)
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
