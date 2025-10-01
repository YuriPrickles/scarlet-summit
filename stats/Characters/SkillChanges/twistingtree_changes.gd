extends SkillChanges

func apply_changed_skills(battler:Battler):
	if battler.has_charm(ID.CharmID.RindGrinder):
		battler.char_data.basic_atk = load("res://stats/Skills/PumpkinSlam.tres")
	if battler.has_charm(ID.CharmID.HuntersSharpener):
		battler.char_data.offense_skill = load("res://stats/Skills/SaplingSapper.tres")
	pass
