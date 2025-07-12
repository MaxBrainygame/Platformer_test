extends CanvasLayer

@onready var message_label: Label = $MessageLabel
@onready var start_button: Button = $StartButton
@onready var message_timer: Timer = $MessageTimer

signal start_game

func _on_button_pressed() -> void:
	start_button.hide()
	message_label.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	message_label.hide()
	
func _start_game_again() -> void:
	message_label.text = "Platformer test"
	message_label.show()
	start_button.show()

func _show_new_game() -> void:
	await message_timer.timeout
	message_timer.stop()
	_start_game_again()

func show_message(text: String) -> void:
	message_label.text = text
	message_label.show()
	message_timer.start()
	
func show_win_game() -> void:
	show_message("You are winner")
	_show_new_game()
	
func show_game_over() -> void:
	show_message("Game over")
	_show_new_game()
	
