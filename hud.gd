## Control the user interface of the game.
extends CanvasLayer

## Notifies `Main` node that the button has been pressed
signal start_game

## Hide the in-game score display
func hide_score():
	$ScoreLabel.hide()


func show_message(text, time: float = 2.0):
	$Message.text = text
	$Message.show()
	$MessageTimer.wait_time = time
	$MessageTimer.start()


func show_game_over(score: int):
	show_message("Game Over\nScore: " + str(score))

	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score, is_speedup):
	$ScoreLabel.text = str(score)
	if is_speedup:
		show_message("Next level", 1.0)
		$ScoreLabel.add_theme_color_override("font_color", Global.IMPORTANT_COLOR)
		$ScoreLabel.add_theme_font_size_override("font_size", Global.IMPORTANT_SIZE)
	else:
		$ScoreLabel.add_theme_color_override("font_color", Global.DEFAULT_COLOR)
		$ScoreLabel.add_theme_font_size_override("font_size", Global.DEFAULT_SIZE)


func _on_start_button_pressed():
	$ScoreLabel.show()
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
