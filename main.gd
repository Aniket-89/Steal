extends Node

@onready var camera: Camera2D = $Player/Camera

@export var start_player: Character
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	Global.current_player = start_player
	GameManager.possessed.connect(update_camera)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_camera(new_player):
	camera.reparent(new_player)
	camera.position = Vector2.ZERO
