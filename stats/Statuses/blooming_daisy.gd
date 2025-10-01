extends StatusEffect

func onTickDown(battler:Battler):
	battler.heal(battler.max_health * 0.14)
	pass
func onTickDown_enemy(enemy:EnemyBattler):
	enemy.heal(enemy.max_health * 0.14)
	pass
