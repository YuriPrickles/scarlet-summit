extends Skill

func onCast_Ally(attacker:Battler,target:Battler):
	for b in State.battler_array:
		if b != attacker:
			var status:StatusEffect = load("res://stats/Statuses/ForestSpirits.tres")
			status.damage_over_time = attacker.attack * 2
			b.add_status([status], [3])
	pass
