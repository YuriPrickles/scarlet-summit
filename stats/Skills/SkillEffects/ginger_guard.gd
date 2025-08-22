extends Skill
func onCast(attacker:Battler,target:EnemyBattler):
	for b in State.battler_array:
		var status:StatusEffect = load("res://stats/Statuses/GingerGuard.tres")
		b.add_status(status, 3)
	pass
