extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.hurt(attacker.char_data.attack * 2)
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.GoToMiddle,
		attacker.attack_all
		)
	pass
