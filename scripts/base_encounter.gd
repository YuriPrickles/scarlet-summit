class_name Encounter
extends Resource

@export var enc_name = "Various Guys"
@export_multiline var enc_desc = "Description"
@export var enc_pic:Texture2D = preload("res://icon.svg")
@export var default_battle_comments:Array[String] = ["A battle begins!"]
@export var enemy_array:Array[Enemy]
@export var party:Array[Character] = [
	load("res://stats/Characters/ScarletHeart.tres"),
	load("res://stats/Characters/GoldenSun.tres"),
	load("res://stats/Characters/TwistingTree.tres"),
	load("res://stats/Characters/ShadeLady.tres")
]
@export var completion_reward:Charm
