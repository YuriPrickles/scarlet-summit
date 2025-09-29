extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.StayInPlace,
		attacker.attack_one.bind(target,1,max(attacker.stored_hits,1))
		)
	attacker.stored_hits = 0
	pass
