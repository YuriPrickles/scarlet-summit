extends Control

func _ready() -> void:
	
	BattleUI.hide()

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/campsite.tscn"))
	pass # Replace with function body.
