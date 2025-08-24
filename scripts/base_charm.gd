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
