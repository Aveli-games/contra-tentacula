extends Control

signal main_menu

func show_game_over():
	if not visible:
		show()
		$AnimationPlayer.play("game_end_loss")
		await $AnimationPlayer.animation_finished
		$MainMenuButton.show()

func _on_main_menu_button_pressed():
	$MainMenuButton.hide()
	$AnimationPlayer.play_backwards("game_end_loss")
	main_menu.emit()
	await $AnimationPlayer.animation_finished
	hide()
