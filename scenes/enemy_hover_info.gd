extends Control

@onready var EnemyName:RichTextLabel = $EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer/EnemyName
@onready var EnemyName2:RichTextLabel = $EnemyInfo/MarginContainer/BuffList/HBoxContainer/EnemyName2
@onready var AttackInfo:RichTextLabel = $EnemyInfo/MarginContainer/VBoxContainer/VBoxContainer/AttackInfo
@onready var BuffListGrid:VBoxContainer = $EnemyInfo/MarginContainer/BuffList/VBoxContainer/GridContainer

@onready var MainPage = $EnemyInfo/MarginContainer/VBoxContainer
@onready var BuffPage = $EnemyInfo/MarginContainer/BuffList

var status_array:Array[StatusEffect]
var page = 0

func _process(_delta: float) -> void:
	var page_array = [MainPage,BuffPage]
	for p in page_array:
		p.hide()
	page_array[page].show()
	
	if Input.is_action_just_pressed("info_scrolldown"):
		page += 1
		if page > 1:
			page = 0
	if Input.is_action_just_pressed("info_scrollup"):
		page -= 1
		if page < 0:
			page = 1
	update_buff_grid()
	move_to_front()


func update_buff_grid():
	for item in BuffListGrid.get_children():
		item.queue_free()
	for status in status_array:
		if status == null or status.turns_left <= 0: continue
		var bufftext:RichTextLabel = RichTextLabel.new()
		bufftext.bbcode_enabled = true
		bufftext.text = "[font_size=24]%s - %d\n[font_size=12]%s" % [status.buff_name, status.turns_left, status.buff_description]
		bufftext.fit_content = true
		bufftext.custom_minimum_size = Vector2(48,48)
		bufftext.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bufftext.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		BuffListGrid.add_child(bufftext)
