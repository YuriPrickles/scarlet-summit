class_name CharmlistButton

extends Button

@onready var charm_title = $MarginContainer/CharmTitle
var charm:Charm

func _process(delta: float) -> void:
	charm_title.text = "[font_size=32]%s" %charm.charm_name


func _on_pressed() -> void:
	State.selected_charmlist_charm = charm
	pass # Replace with function body.
