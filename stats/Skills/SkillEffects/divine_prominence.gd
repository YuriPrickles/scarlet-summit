extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.attack_enemy(
		null,
		attacker.AttackAnimations.StayInPlace,
		attacker.attack_all.bind(5.2/State.enemy_battler_array.size())
		)
	pass
