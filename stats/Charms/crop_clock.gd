extends Charm


func post_turn_effects(battler:Battler):
	if State.turn_counter % 4 == 0 :
		battler.add_status([load("res://stats/Statuses/HarvestTime.tres")],[1])
	pass
