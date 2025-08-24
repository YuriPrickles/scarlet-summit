extends MarginContainer

var char_data:Character
@onready var charname = $VBoxContainer/CharName
@onready var wep_charmlist = $VBoxContainer/WepCharm/WeaponCharmList
@onready var armor_charmlist = $VBoxContainer/ArmorCharm/ArmorCharmList
@onready var badge_a:OptionButton = $VBoxContainer/BadgeA/BadgeListA
@onready var badge_b:OptionButton = $VBoxContainer/BadgeB/BadgeListB
@onready var badge_c:OptionButton = $VBoxContainer/BadgeC/BadgeListC

func _ready():
	charname.text = "[font_size=48][center]%s" % char_data.display_name
	for charmtionary:Dictionary in State.unlocked_charms.values():
		for charm:Charm in charmtionary.keys():
			if charmtionary.get(charm):
				badge_a.add_item(charm.charm_name,charm.charm_ID)
				badge_b.add_item(charm.charm_name,charm.charm_ID)
				badge_c.add_item(charm.charm_name,charm.charm_ID)
