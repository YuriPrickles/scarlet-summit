class_name Character
extends Resource
@export_group("Basic Info")
@export var id:ID.CharID
@export var display_name = "Scarlet Heart"
@export var char_sprite_frames:SpriteFrames = load("res://assets/characters/red/red.tres")
@export var hp = 100
@export var max_hp = 100

@export var defense = 0
@export var attack = 5

@export_group("Skill Info")
@export var basic_atk:Skill
@export var offense_skill:Skill
@export var support_skill:Skill
@export var ultimate:Skill

@export var active_charm_effects:Dictionary

@export var skill_changes_resource:SkillChanges

func on_hurt(battler:Battler,target:EnemyBattler,damage:int):
	if battler.char_data.id == ID.CharID.GoldenSun:
		for b in State.battler_array:
			if b.has_status(ID.StatusID.Flowerfence):
				b.heal(b.max_health * 0.03)

func on_hit(battler:Battler,attacker:EnemyBattler):
	if battler.has_charm(ID.CharmID.ThornHeart):
		battler.attack_reflect(attacker,1 + (defense/10))
	if battler.has_status(ID.StatusID.ForestSpirits):
		var status = battler.status_array[ID.StatusID.ForestSpirits]
		var d_spirits:StatusEffect = load("res://stats/Statuses/DisturbedSpirits.tres")
		d_spirits.damage_over_time = status.damage_over_time
		battler.add_status([d_spirits],[1])
		battler.status_array[ID.StatusID.ForestSpirits] = null

func on_vanquish():
	pass
