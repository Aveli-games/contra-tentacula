extends Node

var selected_squad
var dome_limits = {
	Globals.ResourceType.NONE: 0,
	Globals.ResourceType.FOOD: 6,
	Globals.ResourceType.FUEL: 3,
	Globals.ResourceType.PARTS: 3,
	Globals.ResourceType.RESEARCH: 3
}

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
		var randome = randi_range(0, Globals.ResourceType.size() - 1)
		if dome_limits[randome] != 0:
			child.set_resource_type(randome)
			dome_limits[randome] -= 1
			
	$Domes/Dome.set_sprite("res://art/dome_sprites/Dome_hq_96.png")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and selected_squad:
			selected_squad.position = event.position

func _on_squad_selected(squad_node):
	selected_squad = squad_node
