extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.GetClose,
		attacker.attack_one.bind(target)
		)
	pass
	
