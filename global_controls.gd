extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$ResearchMenuButton.set_icon("res://art/command_sprites/research_sprite_placeholder.png")
	$ResearchMenuButton.set_tooltip("Research")
	$ResearchMenuButton.set_hotkey("R")
	$PlayPauseButton.set_icon("res://art/command_sprites/pause_sprite_placeholder.png")
	$PlayPauseButton.set_tooltip("Pause")
	$PlayPauseButton.set_hotkey("P")
	$MainMenuButton.set_icon("res://art/command_sprites/main_menu_sprite_placeholder.png")
	$MainMenuButton.set_tooltip("Main Menu")
	$MainMenuButton.set_hotkey("M")
