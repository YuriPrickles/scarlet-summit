extends Node

var current_party:Array[Character] = [
	load("res://stats/Characters/ScarletHeart.tres"),
	load("res://stats/Characters/GoldenSun.tres"),
	load("res://stats/Characters/TwistingTree.tres"),
	load("res://stats/Characters/ShadeLady.tres")
	]
var select_circle_held:SelectCircle
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
