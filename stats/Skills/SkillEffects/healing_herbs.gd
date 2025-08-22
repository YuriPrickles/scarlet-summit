extends Skill
	
func onCast_Ally(attacker:Battler,target:Battler):
	target.heal(target.char_data.max_hp * 0.35)
	pass
