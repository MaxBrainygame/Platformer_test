extends CanvasLayer

@onready var message_label: Label = $MessageLabel
@onready var start_button: Button = $StartButton
@onready var message_timer: Timer = $MessageTimer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	
func show_message(text) -> void:
	message_label.text = text
	message_label.show()
	message_timer.start()
	
func show_win_game() -> void:
	show_message("You are winner")
	await message_timer.timeout
	message_timer.stop()
	_start_game_again()
	
