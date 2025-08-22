extends Enemy

func do_attack(enemy:EnemyBattler):
	var battlers = State.battler_array
	var chosen_battler = battlers.pick_random()
	chosen_battler = battlers.pick_random()
	while chosen_battler.health <= 0:
		chosen_battler = battlers.pick_random()
	if State.turn_counter > 0 and randi_range(0,2) >= 1:
		enemy.attack_enemy(
			chosen_battler,
			enemy.AttackAnimations.GetClose,
			enemy.attack_wildhits.bind(3, 0.4)
			)
	else:
		enemy.attack_enemy(
			chosen_battler,
			enemy.AttackAnimations.GetClose,
			enemy.attack_one.bind(chosen_battler, 1)
			)
