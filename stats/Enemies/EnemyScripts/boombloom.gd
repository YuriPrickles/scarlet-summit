extends Enemy

var bomb_ready:bool = true

func filler_func():
	print("filler? i barely know er")

func do_attack(enemy:EnemyBattler):
	var target = enemy.get_target()
	if not bomb_ready and turn_delay == 0:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		turn_delay = 2
		return
		
	if not turn_delay == 0:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		turn_delay -= 1
		if turn_delay == 0:
			turn_delay = 0
			bomb_ready = true
		return
	
	if bomb_ready:
		enemy.attack_enemy(
			target,
			enemy.AttackAnimations.StayInPlace,
			enemy.attack_all.bind(1.3)
			)
		bomb_ready = false
	
func on_hit(enemy:EnemyBattler,attacker:Battler,damage:int):
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
