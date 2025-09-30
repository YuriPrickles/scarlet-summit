extends Enemy

func on_sleep(enemy:EnemyBattler):
	var gift = load("res://stats/Statuses/GiftBasqit.tres")
	for e in State.enemy_battler_array:
		e.add_status([gift],[2])
	for b in State.battler_array:
		b.add_status([gift],[2])
	pass
func do_attack(enemy:EnemyBattler):
	var target = enemy.get_target()
	enemy.attack_enemy(
		target,
		enemy.AttackAnimations.GoToMiddle,
		enemy.attack_all.bind(1)
		)
