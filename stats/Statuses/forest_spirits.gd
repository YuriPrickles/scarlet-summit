extends StatusEffect

func onTickDown(battler:Battler):
	battler.heal(battler.max_health * 0.06)
	pass
func onTickDown_enemy(enemy:EnemyBattler):
	enemy.hurt(damage_over_time)
	pass
func onExpire(_battler:Battler):
	pass
func onExpire_enemy(_enemy:EnemyBattler):
	pass
func onTransfer(battler:Battler, enemy:EnemyBattler):
	var status = battler.status_array[ID.StatusID.DisturbedSpirits]
	status.damage_over_time = battler.status_array[ID.StatusID.DisturbedSpirits].damage_over_time
	var haunted_turns = 1
	enemy.add_status([status],[haunted_turns])
	battler.status_array[ID.StatusID.DisturbedSpirits] = null
