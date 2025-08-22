class_name Skill
extends Resource

enum TargetingType{
	NoSelection,
	SingleEnemy,
	AllEnemies,
	SingleAlly,
	AllTeam,
	Anyone,
	Everyone
}
enum SkillType{
	BasicAttack,
	OffenseSkill,
	SupportSkill,
	Ultimate
}


@export var skill_name = "Crescent Cleaver"
@export_multiline var skill_description = "Hits one enemy."
@export var cost = 0
@export var targeting_type:TargetingType
@export var skill_type:SkillType
@export var animation_oncast:String = "attack"

func cast(attacker,target):
	onCast(attacker,target)
func cast_ally(attacker,target):
	onCast_Ally(attacker,target)
func onCast(_attacker:Battler,_target:EnemyBattler):
	pass

func onCast_Ally(_attacker:Battler,_target:Battler):
	pass

func mana_use(mult = 1,m_cost=cost):
	State.add_mana(-m_cost * mult)
