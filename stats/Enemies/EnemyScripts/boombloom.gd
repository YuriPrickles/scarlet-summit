extends Enemy

var bomb_ready:bool = true

func filler_func():
	print("filler? i barely know er")

func do_attack(enemy:EnemyBattler):
	var battlers = State.battler_array
	var chosen_battler = battlers.pick_random()
	chosen_battler = battlers.pick_random()
	while chosen_battler.health <= 0:
		chosen_battler = battlers.pick_random()
	if not bomb_ready and not is_using_delay:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		is_using_delay = true
		turn_delay = 2
		return
		
	if is_using_delay:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		turn_delay -= 1
		if turn_delay == 0:
			is_using_delay = false
			bomb_ready = true
		return
	if bomb_ready:
		enemy.attack_enemy(
			chosen_battler,
			enemy.AttackAnimations.StayInPlace,
			enemy.attack_all.bind(1.3)
			)
		bomb_ready = false
	
func on_hit(enemy:EnemyBattler,attacker:Battler):
	if bomb_ready:
		enemy.attack_enemy(
			attacker,
			enemy.AttackAnimations.StayInPlace,
			enemy.attack_reflect.bind(attacker, 1)
			)
		bomb_ready = false
		pass
		
	pass

func on_vanquish():
	pass
