extends HBoxContainer

func _on_hard_toggled(toggled_on):
	if toggled_on:
		$Normal.button_pressed = false
		$Easy.button_pressed = false
		Globals.set_difficulty(Globals.DifficultyLevel.HARD)

func _on_normal_toggled(toggled_on):
	if toggled_on:
		$Hard.button_pressed = false
		$Easy.button_pressed = false
		Globals.set_difficulty(Globals.DifficultyLevel.NORMAL)

func _on_easy_toggled(toggled_on):
	if toggled_on:
		$Hard.button_pressed = false
		$Normal.button_pressed = false
		Globals.set_difficulty(Globals.DifficultyLevel.EASY)
