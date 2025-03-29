extends Node

signal died()
signal health_changed(new_health)

@export var max_health: int = 100
var current_health: int

@onready var health: Label = $"../Health"

func _ready() -> void:
	current_health = max_health
	health.text = str(current_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func take_damage(amount:int):
	current_health -= amount
	health.text = str(current_health)
	health_changed.emit(current_health)
	print("enemy health: " + str(current_health))
	if current_health <= 0:
		died.emit()
		

	
