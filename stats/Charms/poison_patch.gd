extends Charm

func on_battle_start_effects(battler:Battler):
	var status:StatusEffect = load("res://stats/Statuses/Corroding.tres")
	status.damage_over_time = battler.max_health/12
	battler.add_status([status],[999])
