extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:		
		velocity.x = direction * SPEED
	else:	
		velocity.x = move_toward(velocity.x, 0, SPEED)
			
	if velocity.y:
		animated_sprite_2d.play("jump")
	elif velocity.x:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	animated_sprite_2d.flip_h = direction < 0

	move_and_slide()
