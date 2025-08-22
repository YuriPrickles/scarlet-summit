class_name Enemy
extends Resource

@export var id:ID.EnemyID
@export var display_name = "Kickleaf"
@export var sprite:Texture2D
@export var hp = 30
@export var max_hp = 30

@export var defense = 0
@export var attack = 5

@export var status_array:Array[StatusEffect]

@export var turn_delay = 0
var is_using_delay

func do_attack(_enemy:EnemyBattler):
	pass
	
func on_hit(_enemy:EnemyBattler,_attacker:Battler):

	pass

func on_vanquish():
	pass
	
