extends StatusEffect

func onTickDown(battler:Battler):
	pass
func onTickDown_enemy(enemy:EnemyBattler):
	pass
func onExpire(_battler:Battler):
	pass
func onExpire_enemy(_enemy:EnemyBattler):
	_enemy.unlock_target()
	pass
