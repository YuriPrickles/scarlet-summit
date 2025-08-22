extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	var chosen_target:EnemyBattler = null
	var stored_hp = -999999999
	for enemy in State.enemy_battler_array:
		if stored_hp < enemy.health:
			stored_hp = enemy.health
			chosen_target = enemy
	attacker.attack_enemy(
		chosen_target,
		attacker.AttackAnimations.StayInPlace,
		attacker.attack_one.bind(chosen_target, 6)
		)
	pass
