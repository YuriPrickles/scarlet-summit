class_name Battler
extends Node2D
@onready var select_circle:SelectCircle = $SelectCircle
@onready var chain:Line2D = $CircleChain
@onready var sprite:AnimatedSprite2D = $Sprite

var char_data:Character
var skill_array:Array[Skill]

var chain_points:PackedVector2Array = [position,position]
var og_position:Vector2

var health
var max_health
var defense
var attack

var hurting = false
var weak_state = false
var turn_done = false

signal finished_action
signal finished_turn

var downed = false
var downed_count = 0

var counters = 0

@export var status_array:Array[StatusEffect]

func _ready() -> void:
	skill_array = [char_data.basic_atk,char_data.offense_skill,char_data.support_skill,char_data.ultimate]
	health = char_data.hp
	max_health = char_data.max_hp
	defense = char_data.defense
	attack = char_data.attack
	select_circle.original_position = select_circle.position + Vector2(0,64)
	sprite.sprite_frames = char_data.char_sprite_frames
	
	og_position = position
	status_array.resize(24)

func _process(_delta: float) -> void:
	downed = health <= 0
	if health <= 0:
		turn_done = true
	var direction_vector = select_circle.position.direction_to(select_circle.original_position)
	chain_points[0] = select_circle.original_position
	chain_points[1] = select_circle.position + Vector2(direction_vector.x,direction_vector.y/2) * 64
	chain.points = chain_points

func update_hp(bar:ProgressBar, new_value):
	bar.value = new_value

func heal(amount:int):
	health += amount if (health + amount == 0) else amount + 10
	update_hp(BattleUI.get_health_bar(char_data.display_name),health)
	var poptext:PopupText = preload("res://scenes/pop_up_text.tscn").instantiate()
	poptext.ptext = "[color=light_green]%s"%amount
	poptext.global_position = global_position + Vector2(randi_range(-16,16),randi_range(-16,16))
	add_child(poptext)

func hurt(damage:int,enemy_attacker:EnemyBattler = null,color_string="white",hurt_sprite_needed=true):
	var already_downed = health <= 0
	print("%s hurt for %s damage" % [char_data.display_name, damage])
	if char_data.id == ID.CharID.ScarletHeart:
		State.add_mana(7)
	else:
		State.add_mana(2)
	if enemy_attacker != null and has_status(ID.StatusID.GingerGuard):
		heal(damage / 4)
		update_hp(BattleUI.get_health_bar(char_data.display_name),health)
		return
	if already_downed:
		damage *= 0.2
	health -= damage
	if health <= 0 and not already_downed:
		BattleUI.set_battle_comment("A knockout!")
		print("%s has been downed!" % char_data.display_name)
		health = -char_data.max_hp / 2 - (downed_count * (char_data.max_hp/10))
		downed_count += 1
		
	update_hp(BattleUI.get_health_bar(char_data.display_name),health)
	if enemy_attacker != null:
		char_data.on_hit(self,enemy_attacker)
	var poptext:PopupText = preload("res://scenes/pop_up_text.tscn").instantiate()
	poptext.ptext = "[color=%s]%s"%[color_string,damage]
	poptext.global_position = global_position + Vector2(randi_range(-16,16),randi_range(-16,16))
	add_child(poptext)
	
	if hurt_sprite_needed:
		hurting = true
		sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		hurting = false
	

func cast_skill(skill:Skill,target,is_ally:bool=false):
	if not is_ally:
		skill.cast(self,target)
	else:
		skill.cast_ally(self,target)
	var mana_mult = 1
	if has_status(ID.StatusID.BeaconPower):
		mana_mult = 0
	skill.mana_use(mana_mult)
	turn_status(true)
	finished_turn.emit()
	pass

enum AttackAnimations{
	GetClose,
	StayInPlace,
	GoToMiddle,
	Filler
}
func attack_enemy(target:EnemyBattler,attack_anim:AttackAnimations,attack_method:Callable,sprite_anim:String="attack"):
	State.someone_doing_something = true
	transfer_statuses(target)
	match attack_anim:
		AttackAnimations.GetClose:
			move_to(target.position - Vector2(150,0),0.4)
			await get_tree().create_timer(0.6).timeout
			sprite.play(sprite_anim)
			await sprite.animation_finished
			attack_method.call()
			await finished_action
			await get_tree().create_timer(0.4).timeout
		AttackAnimations.StayInPlace:
			await get_tree().create_timer(0.6).timeout
			sprite.play(sprite_anim)
			await sprite.animation_finished
			attack_method.call()
			await finished_action
			await get_tree().create_timer(0.4).timeout
		AttackAnimations.GoToMiddle:
			move_to(Vector2(640, 360),0.4)
			await get_tree().create_timer(0.6).timeout
			sprite.play(sprite_anim)
			await sprite.animation_finished
			attack_method.call()
			await finished_action
			await get_tree().create_timer(0.4).timeout
		AttackAnimations.Filler:
			await get_tree().create_timer(0.6).timeout
	State.finish_action()
	sprite.animation = "idle"

#To not cause loops with on-hurt abilities
func attack_reflect(target:EnemyBattler,mult:float=1):
	target.hurt(damage_against(target) * mult,self,false)
	
func attack_one(target:EnemyBattler,mult:float=1):
	target.hurt(damage_against(target) * mult, self)
	return_to_place()
		
func attack_all(mult:float=1):
	for e in State.enemy_battler_array:
		e.hurt(damage_against(e) * mult, self)
	return_to_place()
		
func attack_wildhits(hits:int, mult:float = 1):
	for i in range(hits):
		var e = State.enemy_battler_array.pick_random()
		while e.health <= 0:
			e = State.enemy_battler_array.pick_random()
		e.hurt(damage_against(e) * mult,self)
		await get_tree().create_timer(0.2).timeout
	return_to_place()
		
func move_to(target:Vector2,duration:float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func return_to_place(duration:float = 0.3):
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "position", og_position, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.tween_callback(emit_signal.bind("finished_action"))
func turn_status(value:bool = true):
	turn_done = value

func add_status(status:Array[StatusEffect],turns:Array[int]):
	if status.size() != turns.size():
		print("Error with applying statuses.")
		return
	for i in status.size():
		if turns[i] <= 0: return
		status[i].turns_left = turns[i]
		status_array[status[i].status_ID] = status[i].duplicate()
		var poptext:PopupText = preload("res://scenes/pop_up_text.tscn").instantiate()
		var color:String = "medium_purple" if status[i].is_bad else "light_green"
		poptext.ptext = "[color=%s]%s"%[color,status[i].buff_name]
		poptext.global_position = global_position + Vector2(0, (12 * status.size()) - (12 * i))
		add_child(poptext)
	pass
	
func get_def_mult() -> float:
	var total_mult = 1
	for status in status_array:
		if status == null: continue
		if status.def_mult != 0:
			total_mult += status.def_mult
	total_mult += defense * 0.05
	return total_mult
	
func get_atk_mult() -> float:
	var total_mult = 1
	for status in status_array:
		if status == null: continue
		if status.atk_mult != 0:
			total_mult += status.atk_mult
	return total_mult

func damage_against(target:EnemyBattler):
	return roundi(State.damage_calc(attack,get_atk_mult(),target.get_def_mult()))

func has_status(status_ID:ID.StatusID) -> bool:
	return status_array[status_ID] != null
	
func has_charm(charm_ID:ID.CharmID):
	return State.attached_charms[char_data.id].has(charm_ID)
	
func transfer_statuses(target:EnemyBattler):
	if has_status(ID.StatusID.MiniHaunted):
		var status = status_array[ID.StatusID.MiniHaunted]
		status.damage_over_time = status_array[ID.StatusID.MiniHaunted].damage_over_time
		var haunted_turns = status_array[ID.StatusID.MiniHaunted].turns_left
		target.add_status([status],[haunted_turns])
		status_array[ID.StatusID.MiniHaunted] = null

var is_hovering = false
var hover_display_req_sent = false

func _on_hover_area_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if State.someone_doing_something: return
	if Input.is_action_pressed("dragging") and not is_hovering:
		HoverInfo.hide()
		hover_display_req_sent = false
		return
	if not hover_display_req_sent:
		hover_display_req_sent = true
	else:
		return
	await get_tree().create_timer(1).timeout
	if (not Input.is_action_pressed("dragging") and is_hovering):
		HoverInfo.CharName.text = "[font_size=32] %s" % char_data.display_name
		for sk in skill_array:
			if sk != null:
				if sk.cost != 0:
					HoverInfo.NameArray[sk.skill_type].text = "[font_size=32]%s (%s)" % [sk.skill_name,sk.cost]
				else:
					HoverInfo.NameArray[sk.skill_type].text = "[font_size=32]%s" % [sk.skill_name]
				HoverInfo.DescArray[sk.skill_type].text = "[font_size=16]%s" % sk.skill_description
		HoverInfo.show()
	pass # Replace with function body.

func _on_hover_area_mouse_exited() -> void:
	is_hovering = false
	hover_display_req_sent = false
	HoverInfo.hide()
	pass # Replace with function body.


func _on_hover_area_mouse_entered() -> void:
	is_hovering = true
	pass # Replace with function body.
	
func special_animation_mana_burst():
	State.someone_doing_something = true
	await get_tree().create_timer(0.6).timeout
	sprite.play("selfharm")
	await get_tree().create_timer(1.3).timeout
	for i in range(3):
		hurt(roundi(State.damage_calc(char_data.attack/2,get_atk_mult(),get_def_mult())),null,"crimson",false)
		State.add_mana(char_data.attack/2)
		await get_tree().create_timer(0.25).timeout
	await sprite.animation_finished
	weak_state = true
	State.finish_action()
	pass
