extends Node

var selected_squad

func _ready():
	for child in $Squads.get_children():
		child.location = $Domes/Dome
		child.selected.connect(_on_squad_selected)
	$Squads/Scientists.set_sprite("res://art/squad_sprites/GasMaskScientist_128.png")
	$Squads/Pyros.set_sprite("res://art/squad_sprites/GasmaskPyro_128.png")
	$Squads/Botanists.set_sprite("res://art/squad_sprites/GasmaskBot_128.png")
	$Squads/Engineers.set_sprite("res://art/squad_sprites/GasmaskSanitation_128.png")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and selected_squad:
			selected_squad.position = event.position

func _on_squad_selected(squad_node):
	selected_squad = squad_node
