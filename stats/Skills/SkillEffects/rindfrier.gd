extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.StayInPlace,
		attacker.attack_one.bind(target,1 if target.health <= target.max_health * 0.5 else 1.3)
		)
	pass
