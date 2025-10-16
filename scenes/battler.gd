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
##Currently only used for Sun when using Sunblock and multiple hits from one attack are blocked.
var stored_hits = 0

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

func heal(amount:int,healer_source:Battler=null):
	if healer_source != null:
		amount *= 1.25 if healer_source.has_charm(ID.CharmID.BloomingWreath) else 1
	if char_data.id == ID.CharID.ScarletHeart and has_charm(ID.CharmID.FuryOfTheFir) and has_status(ID.StatusID.BeaconPower):
		State.popatext(self, "Unnecessary", Color.CRIMSON)
		return
	health = min(health + amount,max_health) if not (health + amount >= 0 and health + amount < 10) else amount + 10
	update_hp(BattleUI.get_health_bar(char_data.display_name),health)
	State.popatext(self, amount, Color.LIGHT_GREEN)

func hurt(damage:int,enemy_attacker:EnemyBattler = null,color_string="white",hurt_sprite_needed=true):
	var already_downed = health <= 0
	print("%s hurt for %s damage" % [char_data.display_name, damage])
	if char_data.id == ID.CharID.ScarletHeart:
		State.add_mana(7)
	else:
		State.add_mana(2)
	if enemy_attacker != null and has_status(ID.StatusID.GingerGuard):
		heal(damage / 4,State.look_for_member(ID.CharID.TwistingTree))
		update_hp(BattleUI.get_health_bar(char_data.display_name),health)
		return
	if enemy_attacker != null and has_status(ID.StatusID.OolongerGingerGuard):
		heal(damage / 6,State.look_for_member(ID.CharID.TwistingTree))
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
		
	State.popatext(self,damage,color_string)
	
	if hurt_sprite_needed:
		hurting = true
		sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		hurting = false
	

func cast_skill(skill:Skill,target,is_ally:bool=false):
	turn_status(true)
	finished_turn.emit()
	if not is_ally:
		skill.cast(self,target)
	else:
		skill.cast_ally(self,target)
	var mana_mult = 1
	if has_status(ID.StatusID.BeaconPower):
		mana_mult = 0
	skill.mana_use(mana_mult)
	pass

enum AttackAnimations{
	GetClose,
	StayInPlace,
	GoToMiddle,
	Filler
}
func attack_enemy(target:EnemyBattler,attack_anim:AttackAnimations,attack_method:Callable,sprite_anim:String="attack"):
	State.someone_doing_something = true
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
	
func attack_one(target:EnemyBattler,mult:float=1,hits:int=1):
	transfer_statuses(target,true)
	for i in range(hits):
		char_data.on_hurt(self,target,damage_against(target) * mult)
		target.hurt(damage_against(target) * mult, self)
		await get_tree().create_timer(0.2).timeout
	return_to_place()
		
func attack_all(mult:float=1):
	var e_size = State.enemy_battler_array.size()
	var i = 0
	for e in State.enemy_battler_array:
		char_data.on_hurt(self,e,damage_against(e) * mult)
		e.hurt(damage_against(e) * mult, self)
		transfer_statuses(e, i >= e_size)
		i += 1
	return_to_place()
		
func attack_wildhits(hits:int, mult:float = 1):
	var all_down = true
	var e_size = State.enemy_battler_array.size()
	for i in range(hits):
		var e = State.enemy_battler_array.pick_random()
		while e.health <= 0:
			for en in State.enemy_battler_array:
				if en.health > 0:
					all_down = false
			if all_down: break
			e = State.enemy_battler_array.pick_random()
		char_data.on_hurt(self,e,damage_against(e) * mult)
		e.hurt(damage_against(e) * mult,self)
		transfer_statuses(e, i >= hits)
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
	if has_status(ID.StatusID.WoodcageCurse):
		for s in status:
			if s.is_bad:
				hurt(max_health * 0.05)
			else:
				heal(max_health * 0.03,self)
		return
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
	var c_array = State.attached_charms[char_data.id]
	for data in c_array:
		if data[0] == charm_ID:
			return true
	return false
	
func transfer_statuses(target:EnemyBattler,last_enemy_in_multihit:bool=false):
	for status in status_array:
		if status == null: continue
		status.onTransfer(self,target,last_enemy_in_multihit)

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
		HoverInfo.CharName2.text = "[font_size=32] %s" % char_data.display_name
		HoverInfo.status_array = status_array.duplicate()
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
		hurt(roundi(State.damage_calc(char_data.attack/2,get_atk_mult(),get_def_mult())),null,Color.CRIMSON,false)
		State.add_mana(roundi(State.damage_calc(char_data.attack/4,get_atk_mult(),get_def_mult())))
		await get_tree().create_timer(0.25).timeout
	await sprite.animation_finished
	weak_state = true
	State.finish_action()
	pass
	
func special_animation_flower_power():
	State.someone_doing_something = true
	await get_tree().create_timer(0.6).timeout
	sprite.play("selfharm")
	await get_tree().create_timer(1.3).timeout
	var chosen_target:Battler = null
	var stored_hp = 999999999
	for battler in State.battler_array:
		if battler.char_data.id == ID.CharID.ScarletHeart:
			continue
		if stored_hp > battler.health:
			stored_hp = battler.health
			chosen_target = battler
	for i in range(3):
		hurt(roundi(State.damage_calc(char_data.attack/2.4,get_atk_mult(),get_def_mult())),null,Color.CRIMSON,false)
		State.add_mana(roundi(State.damage_calc(char_data.attack/2.4,get_atk_mult(),get_def_mult())))
		chosen_target.heal(roundi(State.damage_calc(char_data.attack/2.4,get_atk_mult(),get_def_mult())),self)
		await get_tree().create_timer(0.25).timeout
	await sprite.animation_finished
	weak_state = true
	State.finish_action()
	pass
