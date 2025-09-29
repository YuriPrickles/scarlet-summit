class_name Encounter
extends Resource

enum CommentConditions {
	Random,
	Scripted,
	Entry
}

@export var enc_name = "Various Guys"
@export_multiline var enc_desc = "Description"
@export var enc_pic:Texture2D = preload("res://icon.svg")

@export_category("Dialogue")
@export var default_battle_comments:Array[String] = ["A battle begins!","A battle is ongoing."]
@export var comment_conditions:Array[CommentConditions] = [CommentConditions.Entry,CommentConditions.Random]

@export_category("Battlers")
@export var waves:Array[Wave]
@export var party:Array[Character] = [
	preload("res://stats/Characters/ScarletHeart.tres"),
	preload("res://stats/Characters/GoldenSun.tres"),
	preload("res://stats/Characters/TwistingTree.tres"),
	preload("res://stats/Characters/ShadeLady.tres")
]

@export_category("Rewards")
@export var completion_reward:Charm = preload("res://stats/Charms/None.tres")

func get_random_comment():
	var text = default_battle_comments.pick_random()
	var condition:CommentConditions = comment_conditions[default_battle_comments.find(text)]
	while condition != CommentConditions.Random:
		text = default_battle_comments.pick_random()
		condition = comment_conditions[default_battle_comments.find(text)]
	return text

func get_entry_comment():
	var text = default_battle_comments.pick_random()
	var condition:CommentConditions = comment_conditions[default_battle_comments.find(text)]
	while condition != CommentConditions.Entry:
		text = default_battle_comments.pick_random()
		condition = comment_conditions[default_battle_comments.find(text)]
	return text

##Leave in its base form to only get random comments.
##Specify conditions in another script and override this function.
func get_comment():
	return get_random_comment()
