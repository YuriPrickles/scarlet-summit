extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.StayInPlace,
		attacker.attack_one.bind(target,1.5)
		)
	target.add_status([load("res://stats/Statuses/Shined.tres")], [2])
	pass
