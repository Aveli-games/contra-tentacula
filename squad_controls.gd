extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$MoveButton.set_icon("res://art/command_sprites/move_sprite_placeholder.png")
	$MoveButton.set_tooltip("Move")
	$SpecialButton.set_icon("res://art/command_sprites/special_sprite_placeholder.png")
	$SpecialButton.set_tooltip("Special")
	$FightButton.set_icon("res://art/command_sprites/fight_sprite_placeholder.png")
	$FightButton.set_tooltip("Fight")
