extends Control

@export var encounter_list:Array[Encounter]

@onready var battle_button_container = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer/BattleList/BattleButtonContainer
@onready var battle_texture = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer2/VBoxContainer/BattleInfoPanel/MarginContainer/VBoxContainer/BattlePicture
@onready var battle_desc = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer2/VBoxContainer/BattleInfoPanel/MarginContainer/VBoxContainer/BattleDescription

func _ready() -> void:
	BattleUI.hide()
	for enc in encounter_list:
		var battle_button:BattleButton = preload("res://scenes/battle_button.tscn").instantiate()
		battle_button.battle_text = enc.enc_name
		battle_button.enemy_array = enc.enemy_array
		battle_button.party = enc.party
		battle_button.battle_comments = enc.default_battle_comments
		battle_button.battle_desc = enc.enc_desc
		battle_button.battle_picture = enc.enc_pic
		battle_button_container.add_child(battle_button)
		pass

func _process(delta: float) -> void:
	battle_texture.texture = State.battle_picture
	battle_desc.text = State.battle_desc

func _on_start_battle_pressed() -> void:
	BattleUI.show()
	get_tree().change_scene_to_packed(load("res://scenes/Battle.tscn"))
