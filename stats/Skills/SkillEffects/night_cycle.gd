extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.hurt(attacker.char_data.attack)
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.GoToMiddle,
		attacker.attack_all.bind(2)
		)
	pass
