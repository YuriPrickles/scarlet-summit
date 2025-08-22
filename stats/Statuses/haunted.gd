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
