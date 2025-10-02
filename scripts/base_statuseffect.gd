class_name StatusEffect
extends Resource

enum BuffType{
	DamageOverTime,
	StatChange,
	Stunlike,
	Others,
}

@export var status_ID:ID.StatusID
@export var buff_name = "Redvelvet's Curse"
@export_multiline var buff_description = "The soul of Redvelvet is contained within you."
@export var turns_left:int
@export var buff_type:BuffType
@export var is_bad:bool = false
@export var stacking:bool = false
@export var def_mult:float = 0
@export var atk_mult:float = 0
@export var is_stun :bool = false
@export var damage_over_time:int = 0
@export var unremovable: bool = false

func tickDown():
	if stacking: return
	turns_left -= 1
	print("TURNS LEFT FOR STATUS (%s) : %s" % [buff_name,turns_left])

func onTickDown(_battler:Battler):
	pass
func onTickDown_enemy(_enemy:EnemyBattler):
	pass
func onExpire(_battler:Battler):
	pass
func onExpire_enemy(_enemy:EnemyBattler):
	pass
func onTransfer(battler:Battler,_enemy:EnemyBattler):
	pass
