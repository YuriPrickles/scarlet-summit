extends Enemy


var chosen_battler
var already_chose = false

func filler_func():
	print("filler? i barely know er")

func do_attack(enemy:EnemyBattler):
	var battlers = State.battler_array
	if not already_chose:
		chosen_battler = battlers.pick_random()
		already_chose = true
	print("Chosen battler: %s" % chosen_battler.char_data.display_name)
	if not is_using_delay:
		chosen_battler = battlers.pick_random()
		
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		is_using_delay = true
		turn_delay = 3
		return
	while chosen_battler.health <= 0:
		chosen_battler = battlers.pick_random()
	if is_using_delay:
		turn_delay -= 1
		if turn_delay == 0:
			enemy.attack_enemy(
				chosen_battler,
				enemy.AttackAnimations.GetClose,
				enemy.attack_one.bind(chosen_battler,1)
				)
			already_chose = false
			is_using_delay = false
		else:
			enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		return
