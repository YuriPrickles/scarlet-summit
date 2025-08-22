extends Control

@onready var partyhealth = $VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/Partyhealth
@onready var mana_bar:ProgressBar = $VBoxContainer/MarginContainer/Control/HBoxContainer/ManaBar
@onready var battle_comment:RichTextLabel = $VBoxContainer/PanelContainer/MarginContainer2/VBoxContainer/BattleComment
var hbc_scene:PackedScene = preload("res://scenes/healthbar_container.tscn")

func update_mana(new_value):
	var tween = get_tree().create_tween()
	tween.tween_property(mana_bar,"value",new_value,0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
func initialize_healthbars(battler_array:Array):
	for hb in partyhealth.get_children():
		hb.queue_free()
	for ch in battler_array:
		var hb:HealthbarContainer = hbc_scene.instantiate()
		hb.name = ch.char_data.display_name
		hb.char_data = ch.char_data
		hb.max_health_value = ch.max_health
		hb.health_value = ch.health
		partyhealth.add_child(hb)

func set_battle_comment(text:String):
	var final_text = "[font_size=32]%s" % text
	battle_comment.text = final_text
	battle_comment.visible_characters = 0
	var tween = get_tree().create_tween()
	tween.tween_property(battle_comment,"visible_characters",final_text.length(), 1)

func get_health_bar(char_name) -> ProgressBar:
	return partyhealth.get_node(char_name).get_node("HealthBar")
