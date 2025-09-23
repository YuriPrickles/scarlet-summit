class_name BattleButton

extends Button

@onready var battle_title = $MarginContainer/BattleTitle
var encounter:Encounter
var level_position = 0

func _process(delta: float) -> void:
	battle_title.text = "[font_size=32]%s" % encounter.enc_name


func _on_pressed() -> void:
	State.loaded_encounter = encounter
	State.current_level_position = level_position
	pass # Replace with function body.
