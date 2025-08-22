extends Enemy


func filler_func():
	print("filler? i barely know er")

func do_attack(enemy:EnemyBattler):
	var battlers = State.battler_array
	var chosen_battler = battlers.pick_random()
	chosen_battler = battlers.pick_random()
	while chosen_battler.health <= 0:
		chosen_battler = battlers.pick_random()
		
	if is_using_delay:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		turn_delay -= 1
		if turn_delay == 0:
			turn_delay = 2
			is_using_delay = false
			enemy.attack_enemy(
				chosen_battler,
				enemy.AttackAnimations.GoToMiddle,
				enemy.attack_wildhits.bind(5, 1),
				1.6
				)
			return
	else:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		is_using_delay = true
		turn_delay = 2
		return
	enemy.attack_enemy(
		chosen_battler,
		enemy.AttackAnimations.GoToMiddle,
		enemy.attack_wildhits.bind(3, 0.5),
		1.6
		)
	
func on_hit(enemy:EnemyBattler,attacker:Battler):
	enemy.attack_reflect(attacker,1)
	pass

func on_vanquish():
	pass
