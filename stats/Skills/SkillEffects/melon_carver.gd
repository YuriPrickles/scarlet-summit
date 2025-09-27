extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	if target.health <= target.max_health * 0.4:
		target.add_status([load("res://stats/Statuses/LockedTarget.tres")],[2])
		target.lock_target(attacker)
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.GetClose,
		attacker.attack_one.bind(target)
		)
	pass
