extends CharacterBody2D
class_name Character

#@export var animated_sprite: AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $SpritePivot/AnimatedSprite2D
@onready var sprite_pivot: Marker2D = $SpritePivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hitbox: Area2D = $HitboxPivot/Hitbox
@onready var hitbox_pivot: Marker2D = $HitboxPivot

@export var is_possesable: bool
@export var speed := 150
@export var is_player: bool = false

var current_health: int
var direction := Vector2.ZERO
var is_attacking := false
var possessable_targets: Array[Character] = []

func _ready() -> void:
	if is_player:
		current_health = Global.player_max_health
		print("Player health start: " + str(current_health))
	else:
		current_health = Global.enemy_max_health


func _physics_process(delta: float) -> void:
	
	# Player movement
	if is_player and not is_attacking:
		
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		speed = Global.player_speed
		
		if Input.is_action_just_pressed("possess") and possessable_targets.size() > 0:
			#print(possessable_targets.front().name + " " + self.name)
			GameManager.possess(possessable_targets.front(), self)
		
		if Input.is_action_just_pressed("attack"):
			attack()
			
	#Enemy movement
	else:
		var player = Global.current_player if Global else null
	
		if player:
			direction = (player.global_position - self.global_position).normalized()
		else:
			direction = Vector2.ZERO  # Stop moving if there's no player
	
		
	#flipping the sprite to the direction of moving
	if direction.x < 0:
		sprite_pivot.scale.x = -1
		hitbox_pivot.scale.x = -1 
	elif direction.x > 0:
		sprite_pivot.scale.x = 1
		hitbox_pivot.scale.x = 1
	
	#playing the animation based on state
	if direction != Vector2.ZERO and not is_attacking:
		animated_sprite.play("move")
		
	elif direction == Vector2.ZERO and not is_attacking:
		animated_sprite.play("idle")

	velocity = direction * speed
		
	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Character and not body.is_player and body.is_possessable and is_player:
		if body not in possessable_targets:
			possessable_targets.append(body)
			#print("[HITBOX] Added", body.name, "to possessable targets:", possessable_targets)
	elif body is Character and body.is_player:
		attack()


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body is Character and body.is_possesable and not body.is_player:
		possessable_targets.erase(body)
		#print("[HITBOX] Removed", body.name, "from possessable targets:", possessable_targets)


func attack():
	#target.take_damage()
	
	for target in hitbox.get_overlapping_bodies():
		if target is Character and not target.is_player:
			target.take_damage(10)
		
	if is_attacking:
		return
	is_attacking = true
	#print("attacking")
	animation_player.play("attack")
	await animation_player.animation_finished
	is_attacking = false
	

func take_damage(amount: int):
	print("taking damage")
	current_health -= amount
	print(current_health)
	if is_player:
		Global.current_player_health = current_health 
		print("global health: " + str(Global.current_player_health))
	if current_health <= 0:
		#die()
		pass

func die():
	queue_free()
	
