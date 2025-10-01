extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	var mult = 1.7
	for enemy in State.enemy_battler_array:
		State.popatext(enemy,"Debuffs Extended",Color.GOLD)
		for status in enemy.status_array:
			if status != null and status.is_bad:
				status.turns_left += 3
				mult += 0.3
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.GoToMiddle,
		attacker.attack_all.bind(mult)
		)
	pass
