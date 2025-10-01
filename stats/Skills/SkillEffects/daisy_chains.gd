extends Skill
	
func onCast_Ally(attacker:Battler,target:Battler):
	target.add_status([load("res://stats/Statuses/BloomingDaisy.tres")],[3])
	pass
