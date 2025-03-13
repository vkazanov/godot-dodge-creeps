extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

const DEFAULT_COLOR: Color = Color.WHITE
const DEFAULT_SIZE: int = 64
const IMPORTANT_COLOR: Color = Color.RED
const IMPORTANT_SIZE: int = 96

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")

	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	var is_important: bool = score % 5 == 0 and score != 0
	if is_important:
		$ScoreLabel.add_theme_color_override("font_color", IMPORTANT_COLOR)
		$ScoreLabel.add_theme_font_size_override("font_size", IMPORTANT_SIZE)
	else:
		$ScoreLabel.add_theme_color_override("font_color", DEFAULT_COLOR)
		$ScoreLabel.add_theme_font_size_override("font_size", DEFAULT_SIZE)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
