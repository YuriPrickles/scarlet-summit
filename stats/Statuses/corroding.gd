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
	var status = battler.status_array[ID.StatusID.Corroding].duplicate()
	status.damage_over_time = battler.status_array[ID.StatusID.Corroding].damage_over_time * 1.7355
	enemy.add_status([status],[3])
