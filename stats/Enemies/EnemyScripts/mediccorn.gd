extends Enemy



func filler_func():
	print("filler? i barely know er")

func do_attack(enemy:EnemyBattler):
	var battlers = State.battler_array
	var target = enemy.get_target()
	
	if turn_delay == 0:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		turn_delay = 2
		return

	if not turn_delay == 0:
		turn_delay -= 1
		if turn_delay == 0:
			for e in State.enemy_battler_array:
				e.heal(e.tiredness * 160/e.tired_threshold)
			enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		else:
			enemy.attack_enemy(
				target,
				enemy.AttackAnimations.GetClose,
				enemy.attack_one.bind(target, 1)
			)
