extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.StayInPlace,
		attacker.attack_one.bind(target,0.35,7)
		)
	pass
