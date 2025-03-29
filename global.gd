extends Node

var current_player: Character

var player_speed: int = 200
var player_max_health: int = 100
var current_player_health: int
var enemy_max_health: int = 100


func _ready() -> void:
	current_player_health = player_max_health
