extends Node

@export var game_board_scene: PackedScene

var current_board

func _ready():
	current_board = $GameBoardGroup.find_child("GameBoard")
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
	$ButtonBox/ResetButton.show()
	$ButtonBox.show()

func _on_resume_button_pressed():
	resume()
	
func _reset_game_board():
	if current_board:
		DomeConnections.reset()
		Globals.reset()
		current_board.free()
		var new_game_board = game_board_scene.instantiate()
		$GameBoardGroup.add_child(new_game_board)
		new_game_board.main_menu_selected.connect(_on_game_board_main_menu_selected)
		current_board = new_game_board
	resume()

func _on_reset_button_pressed():
	_reset_game_board()

func resume():
	$ButtonBox.hide()
	$AnimationPlayer.play("main_menu_slide_out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
