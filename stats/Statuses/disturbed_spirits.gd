extends StatusEffect

func onTickDown(battler:Battler):
	battler.heal(battler.max_health * 0.03)
	pass
func onTickDown_enemy(enemy:EnemyBattler):
	enemy.heal(enemy.max_health * 0.03)
	pass
func onExpire(_battler:Battler):
	pass
func onExpire_enemy(_enemy:EnemyBattler):
	pass
func onTransfer(battler:Battler, enemy:EnemyBattler):
	var status = battler.status_array[ID.StatusID.MiniHaunted]
	status.damage_over_time = battler.status_array[ID.StatusID.MiniHaunted].damage_over_time
	var haunted_turns = battler.status_array[ID.StatusID.MiniHaunted].turns_left
	enemy.add_status([status],[haunted_turns])
	battler.status_array[ID.StatusID.MiniHaunted] = null
