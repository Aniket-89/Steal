extends Node

signal died()
signal player_health_changed(new_health)
signal possessed(new_player)

var max_player_health := 100
var current_player_health := max_player_health


func take_damage(amount: int):
	current_player_health -= amount
	player_health_changed.emit(current_player_health)
	if current_player_health <= 0:
		died.emit()


# Possession logic
func possess(target, old_player):
	if target is Character:
		old_player.is_player = false
		target.is_player = true
		old_player.queue_free()
		Global.current_player = target
		possessed.emit(target)
