class_name BattleButton

extends Button

@onready var battle_title = $MarginContainer/BattleTitle
var battle_text = "Test Battle"
var party:Array[Character]
var enemy_array:Array[Enemy]
var battle_comments:Array[String]
var battle_desc:String
var battle_picture:Texture2D

func _process(delta: float) -> void:
	battle_title.text = "[font_size=32]%s" % battle_text


func _on_pressed() -> void:
	State.current_party = party
	State.enemy_array = enemy_array
	State.battle_comments = battle_comments
	State.battle_desc = battle_desc
	State.battle_picture = battle_picture
	pass # Replace with function body.
