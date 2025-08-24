extends Control

@onready var party_eq_display = $PanelContainer/MarginContainer/VBoxContainer/PartyEquipmentDisplay

func _ready() -> void:
	
	for char in State.current_party:
		var char_equip_container = preload("res://scenes/char_equip_container.tscn").instantiate()
		char_equip_container.char_data = char
		party_eq_display.add_child(char_equip_container)
		
func _on_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.
