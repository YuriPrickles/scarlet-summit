class_name HealthbarContainer
extends HBoxContainer

@onready var healthbar:ProgressBar = $HealthBar
@onready var charname:RichTextLabel = $CharName
var char_data:Character
var name_to_use = "Someone"
var health_value
var max_health_value

func _ready() -> void:
	charname.text = "[font_size=24][center]%s" % char_data.display_name
	healthbar.max_value = max_health_value
	healthbar.value = health_value
