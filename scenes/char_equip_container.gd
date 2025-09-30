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
	update_charms()
func update_charms():
	var selected_charms = [wep_charmlist.selected,armor_charmlist.selected,badge_a.selected,badge_b.selected,badge_c.selected]
	charname.text = "[font_size=48][center]%s" % char_data.display_name
	wep_charmlist.clear()
	armor_charmlist.clear()
	badge_a.clear()
	badge_b.clear()
	badge_c.clear()
	for charmtionary:Dictionary in State.unlocked_charms.values():
		for charm:Charm in charmtionary.keys():
			if charmtionary.get(charm) and (charm.charm_type == Charm.CharmType.None or charm.charm_type == Charm.CharmType.Weapon):
				wep_charmlist.add_item(charm.charm_name,charm.charm_ID)
				wep_charmlist.set_item_metadata(wep_charmlist.get_item_index(charm.charm_ID),charm)
			if charmtionary.get(charm) and (charm.charm_type == Charm.CharmType.None or charm.charm_type == Charm.CharmType.Armor):
				armor_charmlist.add_item(charm.charm_name,charm.charm_ID)
				armor_charmlist.set_item_metadata(armor_charmlist.get_item_index(charm.charm_ID),charm)
			if charmtionary.get(charm) and (charm.charm_type == Charm.CharmType.None or charm.charm_type == Charm.CharmType.Badge):
				badge_a.add_item(charm.charm_name,charm.charm_ID)
				badge_a.set_item_metadata(badge_a.get_item_index(charm.charm_ID),charm)
				badge_b.add_item(charm.charm_name,charm.charm_ID)
				badge_b.set_item_metadata(badge_b.get_item_index(charm.charm_ID),charm)
				badge_c.add_item(charm.charm_name,charm.charm_ID)
				badge_c.set_item_metadata(badge_c.get_item_index(charm.charm_ID),charm)
	wep_charmlist.select(max(0,selected_charms[0]))
	armor_charmlist.select(max(0,selected_charms[1]))
	badge_a.select(max(0,selected_charms[2]))
	badge_b.select(max(0,selected_charms[3]))
	badge_c.select(max(0,selected_charms[4]))
func update_equippable(charm_index:int):
	pass
