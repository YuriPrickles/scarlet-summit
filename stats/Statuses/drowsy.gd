extends StatusEffect

func onTickDown(battler:Battler):
	pass
func onTickDown_enemy(enemy:EnemyBattler):
	enemy.add_tired(1)
	pass
func onExpire(_battler:Battler):
	pass
func onExpire_enemy(_enemy:EnemyBattler):
	pass
