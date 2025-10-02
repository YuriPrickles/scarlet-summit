extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.GetClose,
		attacker.attack_one.bind(target)
		)
	if target.health <= target.max_health * 0.4:
		for battler in State.battler_array:
			battler.heal(attacker.damage_against(target),attacker)
	pass
