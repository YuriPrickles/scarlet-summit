extends Charm

func on_battle_start_effects(battler:Battler):
	var status:StatusEffect = load("res://stats/Statuses/WoodcageCurse.tres")
	battler.defense += 10
	State.popatext(battler,"+10 DEF", Color.GOLD)
	battler.add_status([status],[999])
