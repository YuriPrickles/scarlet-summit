extends Control

@onready var CharName:RichTextLabel = $CharacterInfo/MarginContainer/VBoxContainer/HBoxContainer/CharName

@onready var BasicAttack:RichTextLabel = $CharacterInfo/MarginContainer/VBoxContainer/VBoxContainer/BasicAttack
@onready var OffenseSkill:RichTextLabel = $CharacterInfo/MarginContainer/VBoxContainer/VBoxContainer2/OffenseSkill
@onready var SupportSkill:RichTextLabel = $CharacterInfo/MarginContainer/VBoxContainer/VBoxContainer3/SupportSkill
@onready var Ultimate:RichTextLabel = $CharacterInfo/MarginContainer/VBoxContainer/VBoxContainer4/Ultimate


@onready var BasicAttackDesc:RichTextLabel = $CharacterInfo/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/BasicATKDesc
@onready var OffenseSkillDesc:RichTextLabel = $CharacterInfo/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/OffenseSkillDesc
@onready var SupportSkillDesc:RichTextLabel = $CharacterInfo/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/SupportSkillDesc
@onready var UltimateDesc:RichTextLabel = $CharacterInfo/MarginContainer/VBoxContainer/VBoxContainer4/HBoxContainer/UltimateDesc

var NameArray:Array[RichTextLabel] = []
var DescArray:Array[RichTextLabel] = []
func _process(_delta: float) -> void:
	move_to_front()
func _ready() -> void:
	NameArray = [BasicAttack,OffenseSkill,SupportSkill,Ultimate]
	DescArray = [BasicAttackDesc,OffenseSkillDesc,SupportSkillDesc,UltimateDesc]
