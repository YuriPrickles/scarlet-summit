extends Control

@export var encounter_list:Array[Encounter]

@onready var battle_button_container = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer/BattleList/BattleButtonContainer
@onready var battle_texture = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer2/VBoxContainer/BattleInfoPanel/MarginContainer/VBoxContainer/BattlePicture
@onready var battle_desc = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer2/VBoxContainer/BattleInfoPanel/MarginContainer/VBoxContainer/BattleDescription


func _ready() -> void:
	BattleUI.hide()
	HoverInfo.hide()
	EnemyHoverInfo.hide()
	for enc in encounter_list:
		var highest_level = 0
		if highest_level > State.max_level_reached:
			break
		highest_level += 1
		var battle_button:BattleButton = preload("res://scenes/battle_button.tscn").instantiate()
		battle_button.encounter = enc
		battle_button.level_position = encounter_list.find(enc)
		battle_button_container.add_child(battle_button)
		battle_button._on_pressed()
		pass

func _process(delta: float) -> void:
	battle_texture.texture = State.loaded_encounter.enc_pic
	battle_desc.text = State.loaded_encounter.enc_desc

func _on_start_battle_pressed() -> void:
	BattleUI.show()
	get_tree().change_scene_to_packed(load("res://scenes/Battle.tscn"))


func _on_equip_pressed() -> void:
	add_child(preload("res://scenes/character_equip.tscn").instantiate())
	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.
