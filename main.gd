extends Node

var selected_squad: Squad

var dome_type_limits = {
	Globals.ResourceType.NONE: 0,
	Globals.ResourceType.FOOD: 6,
	Globals.ResourceType.FUEL: 3,
	Globals.ResourceType.PARTS: 3,
	Globals.ResourceType.RESEARCH: 3
}

func _ready():
	for child in $Squads.get_children():
		child.move($Domes/Dome)
		child.selected.connect(_on_squad_selected)
		
	$Squads/Scientists.set_sprite("res://art/squad_sprites/GasMaskScientist_128.png")
	$Squads/Pyros.set_sprite("res://art/squad_sprites/GasmaskPyro_128.png")
	$Squads/Botanists.set_sprite("res://art/squad_sprites/GasmaskBot_128.png")
	$Squads/Engineers.set_sprite("res://art/squad_sprites/GasmaskSanitation_128.png")
	
	for child in $Domes.get_children():
		child.targeted.connect(_on_dome_targeted)
		if child == $Domes/Dome:
			child.set_resource_type(Globals.ResourceType.FOOD)
			child.set_sprite("res://art/dome_sprites/Dome_hq_96.png")
			dome_type_limits[Globals.ResourceType.FOOD] -= 1
		else:
			var randome = 0
			
			# Get random available resource type for this child
			while dome_type_limits[randome] == 0:
				randome = randi_range(0, Globals.ResourceType.size() - 1)
			child.set_resource_type(randome)
			dome_type_limits[randome] -= 1
	
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

func _on_squad_selected(squad_node: Squad):
	if selected_squad:
		selected_squad.set_highlight(false)
	squad_node.set_highlight(true)
	selected_squad = squad_node
	
func _on_dome_targeted(target_dome: Dome):
	if selected_squad:
		selected_squad.move(target_dome)
