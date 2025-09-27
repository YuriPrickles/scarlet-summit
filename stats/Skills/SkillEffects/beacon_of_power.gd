extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	attacker.hurt(attacker.health + attacker.max_health / 2)
	for b in State.battler_array:
		b.add_status([load("res://stats/Statuses/BeaconPower.tres")],[1])
	pass
