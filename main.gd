extends Node

@export var enemy_scene: PackedScene

@onready var player: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var start_position: Marker2D = $StartPosition
@onready var enemy_position: Marker2D = $EnemyPosition

var enemy: CharacterBody2D

func _on_hud_start_game() -> void:
	player.start(start_position.position)
	_spawn_enemy()

func _on_level_win_game() -> void:
	player.stop(start_position.position)
	_stop_enemy()
	hud.show_win_game()	

func _on_player_game_over() -> void:
	player.stop(start_position.position)
	_stop_enemy()
	hud.show_game_over()

func _spawn_enemy() -> void:
	enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.start(enemy_position.position)

func _stop_enemy() -> void:
	if enemy != null:
		enemy.stop()
	
