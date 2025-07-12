extends TileMapLayer

signal win_game

func _on_exit_body_entered(_body: Node2D) -> void:
	win_game.emit()
