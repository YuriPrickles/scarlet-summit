class_name CharEquipContainer
extends MarginContainer

var char_data:Character
@onready var charname = $VBoxContainer/CharName
@onready var wep_charmlist:OptionButton = $VBoxContainer/WepCharm/WeaponCharmList
@onready var armor_charmlist:OptionButton = $VBoxContainer/ArmorCharm/ArmorCharmList
@onready var badge_a:OptionButton = $VBoxContainer/BadgeA/BadgeListA
@onready var badge_b:OptionButton = $VBoxContainer/BadgeB/BadgeListB
@onready var badge_c:OptionButton = $VBoxContainer/BadgeC/BadgeListC

func _ready():
	charname.text = "[font_size=48][center]%s" % char_data.display_name
	for charmtionary:Dictionary in State.unlocked_charms.values():
		for charm:Charm in charmtionary.keys():
			if charmtionary.get(charm) and (charm.charm_type == Charm.CharmType.None or charm.charm_type == Charm.CharmType.Weapon):
				wep_charmlist.add_item(charm.charm_name,charm.charm_ID)
			if charmtionary.get(charm) and (charm.charm_type == Charm.CharmType.None or charm.charm_type == Charm.CharmType.Armor):
				armor_charmlist.add_item(charm.charm_name,charm.charm_ID)
			if charmtionary.get(charm) and (charm.charm_type == Charm.CharmType.None or charm.charm_type == Charm.CharmType.Badge):
				badge_a.add_item(charm.charm_name,charm.charm_ID)
				badge_b.add_item(charm.charm_name,charm.charm_ID)
				badge_c.add_item(charm.charm_name,charm.charm_ID)
				
func update_equippable(charm_index:int):
	pass
