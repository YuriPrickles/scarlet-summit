extends CanvasLayer

@onready var debug_1 = $Debug_1

func feed_debug(text):
	debug_1.text = text
