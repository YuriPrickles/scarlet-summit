extends Enemy


var already_chose = false

func filler_func():
	print("filler? i barely know er")

func do_attack(enemy:EnemyBattler):
	var battlers = State.battler_array
	var target = enemy.locked_target
	
	if not already_chose:
		enemy.lock_target(enemy.get_target(true))
		target = enemy.locked_target
		already_chose = true
	if turn_delay == 0:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		turn_delay = 3
		return

	while enemy.locked_target.health <= 0:
		enemy.lock_target(enemy.get_target(true))
		target = enemy.locked_target

	if not turn_delay == 0:
		turn_delay -= 1
		if turn_delay == 0:
			enemy.attack_enemy(
				target,
				enemy.AttackAnimations.GetClose,
				enemy.attack_one.bind(target,1)
				)
			enemy.unlock_target()
			already_chose = false
			
		else:
			enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		return
