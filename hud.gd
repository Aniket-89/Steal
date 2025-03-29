extends Control

@onready var health_label: Label = $MarginContainer/HBoxContainer/HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_label.text = str(GameManager.max_player_health) + "/100" 
	GameManager.player_health_changed.connect(update_player_health)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func update_player_health(new_health):
	health_label.text = str(GameManager.current_player_health) + "/100" 
