extends Enemy

func do_attack(enemy:EnemyBattler):
	var battlers = State.battler_array
	var chosen_battler = battlers.pick_random()
	chosen_battler = battlers.pick_random()
	while chosen_battler.health <= 0:
		chosen_battler = battlers.pick_random()
	enemy.attack_enemy(
		chosen_battler,
		enemy.AttackAnimations.GetClose,
		enemy.attack_one.bind(chosen_battler, 1)
		)
