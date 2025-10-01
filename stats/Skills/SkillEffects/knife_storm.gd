extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.hurt(attacker.char_data.attack * 1.1)
	attacker.attack_enemy(
		target,
		attacker.AttackAnimations.GoToMiddle,
		attacker.attack_wildhits.bind(5,1.4)
		)
	pass
