extends Enemy

func do_attack(enemy:EnemyBattler):
	var target = enemy.get_target()
	
	enemy.lock_target(enemy.get_target(true))
	target = enemy.locked_target
	enemy.attack_enemy(
		target,
		enemy.AttackAnimations.GetClose,
		enemy.attack_one.bind(target, 1)
		)
