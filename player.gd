extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 100.0
const DAMAGE = 1.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = $HealthBar
@onready var damage_cast: RayCast2D = $DamageCast

var enemy: CharacterBody2D

func _ready() -> void:
	hide()

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
		
	if direction > 0:
		animated_sprite_2d.flip_h = false
		damage_cast.rotation_degrees = 0.0
	else:
		animated_sprite_2d.flip_h = true
		damage_cast.rotation_degrees = 180.0
	
	if Input.is_action_pressed("attack"):
		animated_sprite_2d.play("attack")
		if damage_cast.is_colliding():
			if enemy == null:
				enemy = damage_cast.get_collider()
			enemy.update_health(DAMAGE)
		else: 
			enemy = null
			

	move_and_slide()
	
func start(pos: Vector2) -> void:
	show()
	$Camera2D.enabled = true
	position = pos
	health_bar.value = MAX_HEALTH
	
func stop() -> void:
	hide()
	$Camera2D.enabled = false
	
func update_health(damage: float) -> void:
	health_bar.value -= damage
