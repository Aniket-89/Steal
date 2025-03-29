extends Control

@onready var health_label: Label = $MarginContainer/HBoxContainer/HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_label.text = str(Global.player_max_health) + "/100" 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_label.text = str(Global.current_player_health) + "/100" 
