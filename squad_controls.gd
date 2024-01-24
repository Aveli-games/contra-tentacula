extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$MoveButton.set_icon("res://art/command_sprites/move_sprite_placeholder.png")
	$MoveButton.set_tooltip("Move")
	$MoveButton.set_hotkey("Q")
	$SpecialButton.set_icon("res://art/command_sprites/special_sprite_placeholder.png")
	$SpecialButton.set_tooltip("Special")
	$SpecialButton.set_hotkey("W")
	$FightButton.set_icon("res://art/command_sprites/fight_sprite_placeholder.png")
	$FightButton.set_tooltip("Fight")
	$FightButton.set_hotkey("E")
