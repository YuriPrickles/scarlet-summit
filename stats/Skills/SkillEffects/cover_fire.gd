extends Skill
	
func onCast_Ally(attacker:Battler,target:Battler):
	for b in State.battler_array:
		for stat in b.status_array:
			if stat != null and stat.status_ID == ID.StatusID.Sunblock:
				b.status_array[stat.status_ID] = null
				print("Sunblock status removed from %s." % b.char_data.display_name)
	target.add_status(load("res://stats/Statuses/Sunblock.tres"),3)
	pass
