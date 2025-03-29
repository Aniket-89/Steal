extends CharacterBody2D
class_name Character

#@export var animated_sprite: AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $SpritePivot/AnimatedSprite2D
@onready var sprite_pivot: Marker2D = $SpritePivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hitbox: Area2D = $HitboxPivot/Hitbox
@onready var hitbox_pivot: Marker2D = $HitboxPivot

@export var is_possesable: bool = true
@export var speed := 150
@export var is_player: bool = false

#var current_health: int = $HealthComponent.current_health
var direction := Vector2.ZERO
var is_attacking := false
var possessable_targets: Array[Character] = []
@onready var health_component: Node = $HealthComponent

func _ready() -> void:
	if is_player:
		GameManager.current_player = self
	
	


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
		var player = GameManager.current_player
	
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
	if body is Character and not body.is_player:
		if body.is_possesable and is_player:
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
		if target is Character:
			target.take_damage(10)
		
	if is_attacking:
		return
	is_attacking = true
	#print("attacking")
	animation_player.play("attack")
	await animation_player.animation_finished
	is_attacking = false
	

func take_damage(amount: int):
	#print("taking damage")
	if is_player:
		GameManager.take_damage(amount)
		#print("global health: " + str(Global.current_player_health))
	else:
		$HealthComponent.take_damage(amount)
		
		

	


func _on_health_component_died() -> void:
	queue_free()
