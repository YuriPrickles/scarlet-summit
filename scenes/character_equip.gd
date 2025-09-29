class_name CharEquipScreen
extends Control

@onready var party_eq_display = $PanelContainer/MarginContainer/VBoxContainer/PartyEquipmentDisplay

func _ready() -> void:
	
	for char in State.loaded_encounter.party:
		var char_equip_container = preload("res://scenes/char_equip_container.tscn").instantiate()
		char_equip_container.char_data = char
		party_eq_display.add_child(char_equip_container)
	for char_eq:CharEquipContainer in party_eq_display.get_children():
		for charm_ID in State.attached_charms.values():
			char_eq.wep_charmlist.select(char_eq.wep_charmlist.get_item_index(charm_ID[0]))
			char_eq.armor_charmlist.select(char_eq.armor_charmlist.get_item_index(charm_ID[1]))
			char_eq.badge_a.select(char_eq.badge_a.get_item_index(charm_ID[2]))
			char_eq.badge_b.select(char_eq.badge_b.get_item_index(charm_ID[3]))
			char_eq.badge_c.select(char_eq.badge_c.get_item_index(charm_ID[4]))
		
func _on_button_pressed() -> void:
	for char_eq:CharEquipContainer in party_eq_display.get_children():
		State.attached_charms[char_eq.char_data.id] = [
			[char_eq.wep_charmlist.get_item_id(char_eq.wep_charmlist.selected),char_eq.wep_charmlist.get_item_metadata(char_eq.wep_charmlist.get_item_index(char_eq.wep_charmlist.get_item_id(char_eq.wep_charmlist.selected)))],
			[char_eq.armor_charmlist.get_item_id(char_eq.armor_charmlist.selected),char_eq.armor_charmlist.get_item_metadata(char_eq.armor_charmlist.get_item_index(char_eq.armor_charmlist.get_item_id(char_eq.armor_charmlist.selected)))],
			[char_eq.badge_a.get_item_id(char_eq.badge_a.selected),char_eq.badge_a.get_item_metadata(char_eq.badge_a.get_item_index(char_eq.badge_a.get_item_id(char_eq.badge_a.selected)))],
			[char_eq.badge_b.get_item_id(char_eq.badge_b.selected),char_eq.badge_b.get_item_metadata(char_eq.badge_b.get_item_index(char_eq.badge_b.get_item_id(char_eq.badge_b.selected)))],
			[char_eq.badge_c.get_item_id(char_eq.badge_c.selected), char_eq.badge_c.get_item_metadata(char_eq.badge_c.get_item_index(char_eq.badge_c.get_item_id(char_eq.badge_c.selected)))]
			]
	queue_free()
	pass # Replace with function body.
	
func is_charm_equipped(charm_index:int) -> bool:
	var is_equipped = false
	for char_eq:CharEquipContainer in party_eq_display.get_children():
		var option_array:Array[OptionButton] = [char_eq.wep_charmlist,char_eq.armor_charmlist,char_eq.badge_a,char_eq.badge_b,char_eq.badge_c]
		for option:OptionButton in option_array:
			if option.get_item_id(charm_index) == ID.CharmID.None:
				return false
			if option.get_item_id(charm_index) == option.get_item_id(charm_index):
				option.set_item_disabled(charm_index,true)
				is_equipped = true
	return is_equipped
