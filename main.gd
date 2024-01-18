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
	
	# TODO: Replace this sample with proper dome randomzing
	for child in $Domes.get_children():
		match randi_range(0, 3):
			0:
				child.set_sprite("res://art/dome_sprites/Dome_food_96.png")
			1:
				child.set_sprite("res://art/dome_sprites/Dome_fuel_96.png")
			2:
				child.set_sprite("res://art/dome_sprites/Dome_parts_96.png")
			3:
				child.set_sprite("res://art/dome_sprites/Dome_science_96.png")
				
	$Domes/Dome.set_sprite("res://art/dome_sprites/Dome_hq_96.png")
	
	# try to put the lower number dome on the left to help prevent repeats, and sort ascending
	var dome_connections = [
		[$Domes/Dome, $Domes/Dome2],
		[$Domes/Dome, $Domes/Dome3],
		[$Domes/Dome, $Domes/Dome4],
		[$Domes/Dome2, $Domes/Dome4],
		[$Domes/Dome2, $Domes/Dome9],
		[$Domes/Dome2, $Domes/Dome5],
		[$Domes/Dome3, $Domes/Dome9],
		[$Domes/Dome4, $Domes/Dome5],
		[$Domes/Dome4, $Domes/Dome6],
		[$Domes/Dome5, $Domes/Dome7],
		[$Domes/Dome5, $Domes/Dome11],
		[$Domes/Dome6, $Domes/Dome7],
		[$Domes/Dome6, $Domes/Dome8],
		[$Domes/Dome7, $Domes/Dome11],
		[$Domes/Dome7, $Domes/Dome12],
		[$Domes/Dome9, $Domes/Dome13],
		[$Domes/Dome10, $Domes/Dome11],
		[$Domes/Dome10, $Domes/Dome14],
		[$Domes/Dome11, $Domes/Dome12],
		[$Domes/Dome11, $Domes/Dome15],
		[$Domes/Dome13, $Domes/Dome14],
		[$Domes/Dome14, $Domes/Dome15],
	]
	DomeConnections.instantiate_network(dome_connections, self)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and selected_squad:
			selected_squad.position = event.position

func _on_squad_selected(squad_node):
	selected_squad = squad_node
