extends StatusEffect

func onTickDown(battler:Battler):
	battler.hurt(damage_over_time)
	pass
func onTickDown_enemy(enemy:EnemyBattler):
	enemy.hurt(damage_over_time)
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
