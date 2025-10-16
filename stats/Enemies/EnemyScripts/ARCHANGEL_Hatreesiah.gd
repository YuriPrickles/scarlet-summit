extends Enemy
var last_hit:Battler
var hit_count = 0

func filler_func():
	print("filler? i barely know er")

func on_hit(enemy:EnemyBattler,battler:Battler,damage):
	super.on_hit(enemy,battler,damage)
	if State.enemy_battler_array.size() == 1 and enemy.tiredness >= 18:
		enemy.summon_enemy(load("res://stats/Enemies/Mediccorn.tres"),enemy.position + Vector2(64,128))
	last_hit = battler
	hit_count += 1 if turn_delay != 1 else 0
	if hit_count >= 3:
		hit_count = 0
		await State.someone_finished_something
		enemy.attack_enemy(
			last_hit,
			enemy.AttackAnimations.GoToMiddle,
			enemy.attack_wildhits.bind(4, 0.8)
			)
	pass

func do_attack(enemy:EnemyBattler):
	if turn_delay == 0:
		enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
		turn_delay = 3
		return
	if not turn_delay == 0:
		turn_delay -= 1
		if turn_delay == 0:
			enemy.attack_enemy(
				last_hit,
				enemy.AttackAnimations.GetClose,
				enemy.attack_one.bind(last_hit, 6.5)
				)
		else: 
			enemy.attack_enemy(null, enemy.AttackAnimations.Filler, filler_func)
			
