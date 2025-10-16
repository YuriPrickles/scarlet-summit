extends Control

@export var encounter_list:Array[Encounter]

@onready var charm_button_container = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer/Charmlist/CharmButtonContainer
@onready var charm_sprite = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer2/VBoxContainer/CharmInfoPanel/MarginContainer/VBoxContainer/CharmSprite
@onready var charm_desc = $MarginContainer/PanelContainer/HBoxContainer/MarginContainer2/VBoxContainer/CharmInfoPanel/MarginContainer/VBoxContainer/CharmDesc


func _ready() -> void:
	BattleUI.hide()
	HoverInfo.hide()
	EnemyHoverInfo.hide()
	#encounter_list = State.encounter_list
	for charmtionary:Dictionary in State.unlocked_charms.values():
		var charmlist_button:CharmlistButton = preload("res://scenes/charmlist_button.tscn").instantiate()
		for charm:Charm in charmtionary.keys():
			charmlist_button.charm = charm
			charm_button_container.add_child(charmlist_button)
			charmlist_button._on_pressed()
		pass

func _process(delta: float) -> void:
	charm_desc.text = State.selected_charmlist_charm.charm_desc

func _on_close_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.
