extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.StayInPlace,
		attacker.attack_one.bind(target)
		)
	var status:StatusEffect = load("res://stats/Statuses/Haunted.tres")
	status.damage_over_time = attacker.attack * 1.5
	target.add_status([status], [3])
	pass
