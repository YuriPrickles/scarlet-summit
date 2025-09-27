extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	if target.health <= target.max_health * 0.5:
		target.add_tired(2)
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.GetClose,
		attacker.attack_one.bind(target)
		)
	pass
