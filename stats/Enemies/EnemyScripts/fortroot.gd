extends Enemy

var extra_base_def = 0
func on_hit(enemy:EnemyBattler, battler:Battler,damage:int):
	super.on_hit(enemy, battler,damage)
	extra_base_def = float(35 * float(float(enemy.tiredness)/float(enemy.tired_threshold)))
	enemy.defense = ceili(defense + extra_base_def)
func do_attack(enemy:EnemyBattler):
	var target = enemy.get_target()
	
	var chosen_target:Battler = null
	var stored_hp = 999999999
	for battler in State.battler_array:
		if stored_hp > battler.health:
			stored_hp = battler.health
			chosen_target = battler
	enemy.lock_target(chosen_target)
	target = enemy.locked_target
	enemy.attack_enemy(
		target,
		enemy.AttackAnimations.GetClose,
		enemy.attack_one.bind(target, 1)
		)
