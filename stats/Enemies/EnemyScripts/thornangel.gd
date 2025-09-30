extends Enemy


func filler_func():
	print("filler? i barely know er")

func do_attack(enemy:EnemyBattler):
		
	var target = enemy.get_target()
	if not turn_delay == 0:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		turn_delay -= 1
		if turn_delay == 0:
			turn_delay = 2
			enemy.attack_enemy(
				target,
				enemy.AttackAnimations.GoToMiddle,
				enemy.attack_wildhits.bind(5, 1),
				1.6
				)
			return
	else:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		turn_delay = 2
		return
	enemy.attack_enemy(
		target,
		enemy.AttackAnimations.GoToMiddle,
		enemy.attack_wildhits.bind(3, 0.5),
		1.6
		)
	
func on_hit(enemy:EnemyBattler,attacker:Battler,damage:int):
	super.on_hit(enemy,attacker,damage)
	enemy.attack_reflect(attacker,1)
	pass

func on_vanquish():
	pass
