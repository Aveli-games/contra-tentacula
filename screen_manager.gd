extends Node

@export var game_board_scene: PackedScene

var current_board

func _ready():
	current_board = $GameBoardGroup.find_child("GameBoard")
	get_tree().paused = true
	Globals.research_win.connect(_on_victory)

func _on_start_button_pressed():
	$ButtonBox.hide()
	$AnimationPlayer.play("main_menu_fade_out")
	await $AnimationPlayer.animation_finished
	if get_tree().paused == true:
		current_board.toggle_pause()

func _on_game_board_main_menu_selected():
	if $ButtonBox.visible:
		resume()
		return
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
		new_game_board.game_over.connect(_on_game_over_loss)
		current_board = new_game_board

func _on_reset_button_pressed():
	_reset_game_board()
	resume()

func resume():
	$ButtonBox.hide()
	$AnimationPlayer.play("main_menu_slide_out")
	await $AnimationPlayer.animation_finished
	if get_tree().paused == true:
		current_board.toggle_pause()

func _on_game_over_loss():
	if not $GameEndLoss.visible && not $GameEndWin.visible:
		$GameEndLoss.show_game_over()

func _on_game_end_loss_main_menu():
	get_tree().paused = true
	$AnimationPlayer.play_backwards("main_menu_fade_out")
	await $AnimationPlayer.animation_finished
	_reset_game_board()
	$ButtonBox/ResumeButton.hide()
	$ButtonBox/ResetButton.hide()
	$ButtonBox/StartButton.show()
	$ButtonBox.show()

func _on_victory():
	if not $GameEndLoss.visible && not $GameEndWin.visible:
		$GameEndWin.show_victory()
