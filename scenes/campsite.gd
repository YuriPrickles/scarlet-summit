extends Control

func _ready() -> void:
	BattleUI.hide()
func _on_continue_adventure_pressed() -> void:
	add_child(preload("res://scenes/battle_select.tscn").instantiate())
	pass # Replace with function body.
