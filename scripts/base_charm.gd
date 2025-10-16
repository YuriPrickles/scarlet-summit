class_name Charm

extends Resource

enum CharmType {
	None,
	Weapon,
	Armor,
	Badge
}

@export var charm_ID:ID.CharmID
@export var charm_name = ""
@export var charm_type:CharmType
@export_multiline var charm_desc:String = "It does something!"

func on_battle_start_effects(battler:Battler):
	pass
func post_turn_effects(battler:Battler):
	pass
