extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hud_start_game() -> void:
	$Player.start($StartPosition.position)

func _on_level_win_game() -> void:
	$Player.hide()
	$HUD.show_win_game()	
