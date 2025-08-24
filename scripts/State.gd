extends Node

var current_party:Array[Character] = [
	load("res://stats/Characters/ScarletHeart.tres"),
	load("res://stats/Characters/GoldenSun.tres"),
	load("res://stats/Characters/TwistingTree.tres"),
	load("res://stats/Characters/ShadeLady.tres")
	]

var unlocked_charms:Dictionary
var attached_charms:Dictionary

var charm_list_ref:Array[Charm]
	
var enemy_array:Array[Enemy]
var battle_comments:Array[String]
var battle_desc:String
var battle_picture:Texture2D

var max_level_reached = 0
var levels_beaten:Array[bool]
var current_level_position
var current_reward:Charm

var select_circle_held:SelectCircle

func _ready() -> void:
	
	levels_beaten.resize(500)
	levels_beaten.fill(false)
func set_battler_arrays(array, e_array):
	battler_array.clear()
	battler_array.append_array(array)
	enemy_battler_array.clear()
	enemy_battler_array.append_array(e_array)
var battler_array:Array[Battler]
var enemy_battler_array:Array[EnemyBattler]

var someone_doing_something = false
signal someone_finished_something

var turn_counter:int = 0
var mana:int = 0

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
