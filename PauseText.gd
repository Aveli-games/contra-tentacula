extends Label

func _input(event):
	if event.is_action_pressed("Pause"):
		toggle_pause()

func _on_pause_button_pressed():
	get_tree().paused = true
	show()
	
func _on_close_button_pressed():
	hide()
	get_tree().paused = false

func _on_play_pause_button_selected(button: TextureIcon):
	toggle_pause()

func toggle_pause():
	if get_tree().paused == false:
		_on_pause_button_pressed()
	else:
		_on_close_button_pressed()
