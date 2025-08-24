class_name Charm

extends Resource

enum CharmType {
	Weapon,
	Armor,
	Badge
}

@export var charm_ID:ID.CharmID
@export var charm_name = ""
@export var charm_type:CharmType
