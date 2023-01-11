extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	# show 'game over' message until timer runs out
	show_message("Game Over")
	yield($MessageTimer, "timeout")

	$Message.text = "Avoiddance"
	$Message.show()

	# wait for a new runtime-created timer to run out before showing the start button
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
