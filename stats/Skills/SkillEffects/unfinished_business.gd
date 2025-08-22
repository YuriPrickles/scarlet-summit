extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	var mult = 1
	for enemy in State.enemy_battler_array:
		for status in enemy.status_array:
			if status != null and status.is_bad:
				mult += 0.5
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.GoToMiddle,
		attacker.attack_all.bind(mult)
		)
	pass
