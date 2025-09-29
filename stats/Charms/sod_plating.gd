extends Charm

func post_turn_effects(battler:Battler):
	if State.turn_counter % 1 == 0 :
		State.popatext(battler,"DEF +4",Color.GOLD)
		battler.defense += 4
	pass
