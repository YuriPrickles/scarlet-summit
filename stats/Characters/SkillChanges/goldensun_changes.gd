extends SkillChanges

func apply_changed_skills(battler:Battler):
	if battler.has_charm(ID.CharmID.RindGrinder):
		battler.char_data.basic_atk = preload("res://stats/Skills/Rindfrier.tres")
	pass
