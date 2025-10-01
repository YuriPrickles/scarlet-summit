extends SkillChanges

func apply_changed_skills(battler:Battler):
	if battler.has_charm(ID.CharmID.RindGrinder):
		battler.char_data.basic_atk = load("res://stats/Skills/PumpkinSlam.tres")
	if battler.has_charm(ID.CharmID.HuntersSharpener):
		battler.char_data.offense_skill = load("res://stats/Skills/SaplingSapper.tres")
	if battler.has_charm(ID.CharmID.FlowerBands):
		battler.char_data.support_skill = load("res://stats/Skills/DaisyChains.tres")
	if battler.has_charm(ID.CharmID.FuryOfTheFir):
		battler.char_data.ultimate = load("res://stats/Skills/OolongerGingerGuard.tres")
	pass
