extends CharacterBody2D

const SPEED = 150.0
const CHASE_SPEED = 300.0
const MAX_HEALTH = 100.0
const DAMAGE = 5.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_cast: RayCast2D = $DamageCast
@onready var damage_timer: Timer = $DamageTimer
@onready var health_bar: ProgressBar = $HealthBar

var direction: float = 1
var player: CharacterBody2D
var chase: bool
var attack: bool

func _ready() -> void:
	hide()

func _physics_process(_delta: float) -> void:	
	if chase:
		_set_chasing()		
	else:
		_set_patrol()
		
	_attack()
	_set_elements_and_animation()
	
	move_and_slide()
			
func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true
		player = body

func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false
		player = null 
		
func _on_damage_timer_timeout() -> void:
	if player != null:
		player.update_health(DAMAGE)

func _set_chasing() -> void:
	velocity = position.direction_to(player.position) * CHASE_SPEED
	if player.position.x > position.x:
		direction = 1
	else:
		direction = -1

func _set_patrol() -> void:
	if is_on_wall():
		direction = -direction
		velocity.x = SPEED * direction

func _attack() -> void:
	if damage_cast.is_colliding():
		attack = true
		if damage_timer.is_stopped():
			damage_timer.start()
	else:
		damage_timer.stop()	
		attack = false

func _set_elements_and_animation() -> void:
	if attack:
		animated_sprite.play("attack")
	else:
		animated_sprite.play("walk") 
	if direction > 0:
		animated_sprite.flip_h = true
		damage_cast.rotation_degrees = 180.0
	else:
		animated_sprite.flip_h = false
		damage_cast.rotation_degrees = 0.0

func start(pos: Vector2) -> void:
	show()
	position = pos
	health_bar.value = MAX_HEALTH
	
func stop() -> void:
	queue_free()
	
func update_health(damage: float) -> void:
	health_bar.value -= damage
	if health_bar.value == 0:
		stop()
