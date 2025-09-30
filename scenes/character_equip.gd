extends Control

@onready var party_eq_display = $PanelContainer/MarginContainer/VBoxContainer/PartyEquipmentDisplay

func _ready() -> void:
	for char in State.current_party:
		var char_equip_container = preload("res://scenes/char_equip_container.tscn").instantiate()
		char_equip_container.char_data = char
		party_eq_display.add_child(char_equip_container)
	pass

func update():
	
	move_to_front()
	for char_eq:CharEquipContainer in party_eq_display.get_children():
		char_eq.update_charms()
		var is_in_party = false
		for char in State.loaded_encounter.party:
			if char_eq.char_data.id == char.id:
				is_in_party = true
		if not is_in_party:
			char_eq.hide()
		else:
			char_eq.show()
	
	#for char_eq:CharEquipContainer in party_eq_display.get_children():
		#for charm_ID in State.attached_charms.values():
			#var nodelist:Array[OptionButton] = [char_eq.wep_charmlist,char_eq.armor_charmlist,char_eq.badge_a,char_eq.badge_b,char_eq.badge_c]
			#for val_arr in charm_ID:
				#if val_arr is int and val_arr == 0:
					#continue
				#for node in nodelist:
					#node.select(node.get_item_index(val_arr[2]))
	

func _on_button_pressed() -> void:
	for char_eq:CharEquipContainer in party_eq_display.get_children():
		var nodelist:Array[OptionButton] = [char_eq.wep_charmlist,char_eq.armor_charmlist,char_eq.badge_a,char_eq.badge_b,char_eq.badge_c]
		var to_attach:Array = []
		for node in nodelist:
			to_attach.append([
				node.get_item_id(node.selected),
				node.get_item_metadata(
					node.get_item_index(
						node.get_item_id(
							node.selected)))
			])
		State.attached_charms[char_eq.char_data.id] = to_attach.duplicate()
	hide()
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
