extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	target.add_status([load("res://stats/Statuses/Sapped.tres")], [3])
	pass
