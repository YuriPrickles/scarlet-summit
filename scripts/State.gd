extends Node

var current_party:Array[Character] = [
	load("res://stats/Characters/ScarletHeart.tres"),
	load("res://stats/Characters/GoldenSun.tres"),
	load("res://stats/Characters/TwistingTree.tres"),
	load("res://stats/Characters/ShadeLady.tres")
	]

var unlocked_charms:Dictionary
var attached_charms:Dictionary

var charm_list_ref:Array[Charm] = [
	preload("res://stats/Charms/AbundantSoils.tres"),
	preload("res://stats/Charms/CropClock.tres"),
	preload("res://stats/Charms/RindGrinder.tres"),
	preload("res://stats/Charms/SodPlating.tres"),
	preload("res://stats/Charms/ThornHeart.tres")
	]

var loaded_encounter:Encounter

var max_level_reached = 0
var levels_beaten:Array[bool]
var current_level_position

var select_circle_held:SelectCircle

var battler_array:Array[Battler]
var enemy_battler_array:Array[EnemyBattler]

var someone_doing_something = false
signal someone_finished_something

var turn_counter:int = 0
var mana:int = 0

func _ready() -> void:
	attached_charms = {
		0: [0,0,0,0,0],
		1: [0,0,0,0,0],
		2: [0,0,0,0,0],
		3: [0,0,0,0,0]
	}
	var none_charm:Charm = preload("res://stats/Charms/None.tres")
	var charmtionary:Dictionary
	charmtionary[none_charm] = true
	State.unlocked_charms[none_charm.charm_ID] = charmtionary
	levels_beaten.resize(500)
	levels_beaten.fill(false)

func _process(delta: float) -> void:
	if Input.is_action_pressed("unlock_all_levels"):
		max_level_reached = 99999
		levels_beaten.fill(true)
	if Input.is_action_pressed("unlock_all_charms"):
		for charm:Charm in charm_list_ref:
			var charmtionary:Dictionary
			charmtionary[charm] = true
			State.unlocked_charms[charm.charm_ID] = charmtionary

func set_battler_arrays(array, e_array):
	battler_array.clear()
	battler_array.append_array(array)
	enemy_battler_array.clear()
	enemy_battler_array.append_array(e_array)



func damage_calc(base_atk,atk_mult,def_mult) -> int:
	var adjusted_atk = base_atk
	adjusted_atk *= atk_mult
	adjusted_atk /= def_mult
	return adjusted_atk

func finish_action():
	someone_doing_something = false
	print("Action finished")
	emit_signal("someone_finished_something")
	
##Use negative values to "use" mana.
func add_mana(amount):
	set_mana(mana + amount)
func set_mana(new_mana):
	mana = min(max(0, new_mana),100)
	BattleUI.update_mana(mana)

func look_for_member(battler_ID:ID.CharID) -> Battler:
	for battler in battler_array:
		if battler.char_data.id == battler_ID:
			return battler
	return null
