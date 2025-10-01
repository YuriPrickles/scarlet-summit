extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.StayInPlace,
		attacker.attack_one.bind(target,1.2)
		)
	target.add_tired(7)
	pass
