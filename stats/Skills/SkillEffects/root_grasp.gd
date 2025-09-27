extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	target.add_status([load("res://stats/Statuses/Rooted.tres")], [2])
	pass
