extends CharacterBody2D

signal game_over

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 100.0
const DAMAGE = 1.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = $HealthBar
@onready var damage_cast: RayCast2D = $DamageCast

var enemy: CharacterBody2D
var direction: float

func _ready() -> void:
	hide()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	direction = Input.get_axis("move_left", "move_right")
	
	_put_velocity_from_direction()
	_set_elemets_and_animation()				
	_attack()		
	move_and_slide()
	
func start(pos: Vector2) -> void:
	show()
	$Camera2D.enabled = true
	position = pos
	health_bar.value = MAX_HEALTH
	
func stop(pos: Vector2) -> void:
	hide()
	position = pos
	$Camera2D.enabled = false

func _put_velocity_from_direction() -> void:
	if direction:		
		velocity.x = direction * SPEED
	else:	
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _set_elemets_and_animation() -> void:
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

func _attack() -> void:
	if not Input.is_action_pressed("attack"):
		return
		
	animated_sprite_2d.play("attack")
	if damage_cast.is_colliding():
		if enemy == null:
			enemy = damage_cast.get_collider()
		else:
			enemy.update_health(DAMAGE)
	else: 
		enemy = null
	
func update_health(damage: float) -> void:
	health_bar.value -= damage
	if health_bar.value == 0:
		game_over.emit()
