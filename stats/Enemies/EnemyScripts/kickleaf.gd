extends Enemy

func do_attack(enemy:EnemyBattler):
	var target = enemy.get_target()
	if State.turn_counter > 0 and randi_range(0,2) >= 1:
		enemy.attack_enemy(
			target,
			enemy.AttackAnimations.GoToMiddle,
			enemy.attack_wildhits.bind(3, 0.4)
			)
	else:
		enemy.attack_enemy(
			target,
			enemy.AttackAnimations.GetClose,
			enemy.attack_one.bind(target, 1)
			)
