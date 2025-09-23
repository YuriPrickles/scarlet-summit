extends Encounter

func get_comment():
	if State.turn_counter == 1:
		return default_battle_comments[4]
	if State.mana <= 20:
		return default_battle_comments[1]
	return get_random_comment()
