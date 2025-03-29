extends Node

@export var enemy_scene: PackedScene
@export var spawn_rate: int = 2

@export var spawn_timer: Timer

@export var spawn_area: Rect2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_spawn_area()
	
	if spawn_timer:
		spawn_timer.wait_time = spawn_rate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.position = get_random_position()
	get_parent().add_child(enemy)  # First, add to the scene tree

	enemy.is_possesable = true  # Now set `is_possesable` after it's in the tree


func get_random_position():
	var x = randf_range(spawn_area.position.x, spawn_area.end.x)
	var y = randf_range(spawn_area.position.y, spawn_area.end.y)
	return Vector2(x, y)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
