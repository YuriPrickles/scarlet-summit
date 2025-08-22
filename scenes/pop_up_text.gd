class_name PopupText
extends RichTextLabel

var ptext = "hi"
func _init() -> void:
	pass

func _ready() -> void:
	text = "[font_size=32][center][outline_color=black][outline_size=4]%s" % ptext
	$BackPop.text = "[font_size=32][center][outline_color=black][outline_size=4]%s" % ptext
	$AnimationPlayer.play("poppyuppy_withback")
	await $AnimationPlayer.animation_finished
	queue_free()
