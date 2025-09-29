extends Charm

func post_turn_effects(battler:Battler):
	battler.heal(battler.max_health * 0.03)
