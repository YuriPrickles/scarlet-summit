class_name Enemy
extends Resource

@export var id:ID.EnemyID
@export var display_name = "Kickleaf"
@export var sprite:Texture2D
@export var hp = 30
@export var max_hp = 30
@export var tired_threshold = 15

@export var defense = 0
@export var attack = 5

@export var status_array:Array[StatusEffect]

@export var turn_delay = 0
var is_using_delay

@export_multiline var attack_desc:String

func do_attack(_enemy:EnemyBattler):
	pass

##On-hit effects trigger before damage.
func on_hit(_enemy:EnemyBattler,_attacker:Battler,damage:int):
	_enemy.add_tired(1)
	
	if _enemy.health - damage <= _enemy.max_health * 0.5 and _enemy.health > _enemy.max_health * 0.5:
		_enemy.add_tired(3)
		_enemy.add_status([load("res://stats/Statuses/Drowsy.tres")],[999])
	pass

func on_vanquish():
	pass
	
