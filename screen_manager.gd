extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

func _on_start_button_pressed():
	$ButtonBox.hide()
	$AnimationPlayer.play("main_menu_fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false

func _on_game_board_main_menu_selected():
	get_tree().paused = true
	$AnimationPlayer.play("main_menu_slide_in")
	await $AnimationPlayer.animation_finished
	$ButtonBox/StartButton.hide()
	$ButtonBox/ResumeButton.show()
	$ButtonBox.show()

func _on_resume_button_pressed():
	$ButtonBox.hide()
	$AnimationPlayer.play("main_menu_slide_out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
