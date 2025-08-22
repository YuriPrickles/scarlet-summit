extends Skill

func onCast_Ally(attacker:Battler,target:Battler):
	for b in State.battler_array:
		if b != attacker:
			var status:StatusEffect = load("res://stats/Statuses/MiniHaunted.tres")
			status.damage_over_time = attacker.attack * 0.5
			b.add_status(status, 3)
	pass
