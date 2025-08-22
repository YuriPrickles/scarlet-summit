class_name SelectCircle
extends Node2D
enum AttackTypes{
	BasicAttack,
	OffenseSkill,
	SupportSkill,
	Ultimate
}
var tethered_character = -1
var selecting = false
var snapping = false
var battler_snapped:Battler
var enemy_battler_snapped:EnemyBattler
var snap_position:Vector2
var original_position:Vector2 = Vector2(0,0)
var selected_attack:AttackTypes = AttackTypes.BasicAttack
var do_not_snap = false
var disabled = false

func _process(_delta: float) -> void:
	var anim = ("selecting" if not owner.weak_state else "weakselect") if selecting else ("idle" if not owner.weak_state else "weakidle")
	if not State.someone_doing_something and not owner.hurting:
		if owner.health < 0: anim = "weakidle"
		owner.sprite.play(anim)
	owner.chain.modulate = modulate
	DebugView.feed_debug(
		"[font_size=16]
		Selected Attack: %s
		" % 
		selected_attack
	)
	if State.someone_doing_something or owner.turn_done or (State.select_circle_held != self and State.select_circle_held != null):
		owner.chain.hide()
		hide()
		disabled = true
		return
	else:
		owner.chain.show()
		show()
		disabled = false
	determine_attack_type()
	if disabled: return
	if selecting:
		if not snapping:
			global_position = get_global_mouse_position()
		else:
			global_position = snap_position
			if enemy_battler_snapped != null:
				modulate = Color.CRIMSON
			if battler_snapped != null:
				modulate = Color.PALE_GREEN
			if global_position.distance_to(get_global_mouse_position()) >= 132:
				if enemy_battler_snapped != null:
					enemy_battler_snapped = null
				if battler_snapped != null:
					battler_snapped = null
				snapping = false
				modulate = Color.PALE_TURQUOISE
	if !Input.is_action_pressed("dragging"):
		DebugView.feed_debug(
			"[font_size=16]
			Selected Attack: %s
			" % 
			selected_attack
		)
		if selected_attack != AttackTypes.Ultimate:
			if enemy_battler_snapped != null:
				send_attack(owner,enemy_battler_snapped)
			if battler_snapped != null:
				send_attack_ally(owner,battler_snapped)
		else:
			if battler_snapped != null or enemy_battler_snapped != null:
				send_attack(owner,null)
		State.select_circle_held = null
		selecting = false
		snapping = false
		do_not_snap = false
		battler_snapped = null
		enemy_battler_snapped = null
		modulate = Color.PALE_TURQUOISE
		position = original_position

func send_attack(attacker:Battler,target:EnemyBattler):
	match selected_attack:
		AttackTypes.BasicAttack:
			State.add_mana(3)
			attacker.cast_skill(attacker.char_data.basic_atk,target)
		AttackTypes.OffenseSkill:
			if attacker.char_data.offense_skill.cost <= State.mana or attacker.has_status(ID.StatusID.BeaconPower):
				attacker.cast_skill(attacker.char_data.offense_skill,target)
			else:
				print("Insufficient mana!")
		AttackTypes.Ultimate:
			if attacker.char_data.ultimate.cost <= State.mana or attacker.has_status(ID.StatusID.BeaconPower):
				attacker.cast_skill(attacker.char_data.ultimate,target)
			else:
				print("Insufficient mana!")
	pass
func send_attack_ally(attacker:Battler,target:Battler):
	match selected_attack:
		AttackTypes.SupportSkill:
			if attacker.char_data.support_skill.cost <= State.mana or attacker.has_status(ID.StatusID.BeaconPower):
				attacker.cast_skill(attacker.char_data.support_skill,target,true)
			else:
				print("Insufficient mana!")
	pass

func determine_attack_type():
	if Input.is_action_pressed("basic_atk"):
		selected_attack = AttackTypes.BasicAttack
		do_not_snap = true
		return
	if Input.is_action_pressed("skill_atk"):
		do_not_snap = false
		if enemy_battler_snapped != null:
			selected_attack = AttackTypes.OffenseSkill
			return
		if battler_snapped != null:
			selected_attack = AttackTypes.SupportSkill
			return
	if Input.is_action_pressed("ultimate"):
		do_not_snap = false
		if enemy_battler_snapped != null:
			selected_attack = AttackTypes.Ultimate
			return
		if battler_snapped != null:
			selected_attack = AttackTypes.Ultimate
			return
	DebugView.feed_debug(
		"[font_size=16]
		Selected Attack: %s
		" % 
		selected_attack
	)

func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if State.select_circle_held != self and State.select_circle_held != null:
		return
	if Input.is_action_pressed("dragging"):
		State.select_circle_held = self
		selecting = true
		if not snapping:
			modulate = Color.PALE_TURQUOISE


func _on_select_collision_area_entered(area: Area2D) -> void:
	if area.name == "HoverArea":
		return
	if area.owner is EnemyBattler:
		snapping = true
		snap_position = area.global_position
		enemy_battler_snapped = area.owner
		print("snapping onto %s" % area.owner)
		modulate = Color.PALE_GREEN
	if area.owner is Battler and area.owner != owner and not do_not_snap:
		snapping = true
		snap_position = area.global_position
		battler_snapped = area.owner
		print("snapping onto %s" % area.owner)
		modulate = Color.CRIMSON
	pass # Replace with function body.
