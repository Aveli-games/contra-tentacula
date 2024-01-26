extends Node

signal game_over
signal victory
signal main_menu_selected

var selected_squad: Squad
var selected_action: Globals.ActionType = Globals.ActionType.NONE

func _ready():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
	Input.set_custom_mouse_cursor(load("res://art/command_sprites/fight_sprite_placeholder.png"), 0, Vector2(12, 12))
	
	$Squads/Scientists.set_type(Globals.SquadType.SCIENTIST)
	$Squads/Pyros.set_type(Globals.SquadType.PYRO)
	$Squads/Botanists.set_type(Globals.SquadType.BOTANIST)
	$Squads/Engineers.set_type(Globals.SquadType.ENGINEER)
	
	for child in $Squads.get_children():
		child.command(Globals.ActionType.FIGHT, $Domes/Dome)
		child.selected.connect(_on_squad_selected)
		if child.squad_type == Globals.SquadType.SCIENTIST:
			child.research_toggled.connect(_on_research_toggled)
		for squad_button in $UI/RightSidebar/SquadDisplay.get_children():
			squad_button.selected.connect(_on_control_selected)
			if not squad_button.squad_link:
				squad_button.set_squad(child)
				break
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
	
	# create resource type pool
	var resource_type_array = []
	for key in Globals.DOME_TYPE_LIMITS.keys():
		var number_of_resource = Globals.DOME_TYPE_LIMITS[key]
		var to_add = []
		to_add.resize(number_of_resource)
		to_add.fill(key)
		resource_type_array.append_array(to_add)
	resource_type_array.shuffle()
	
	for child in $Domes.get_children():
		child.targeted.connect(_on_dome_targeted)
		child.production_changed.connect(_on_dome_production_changed)
		child.lost.connect(_on_dome_lost)
		child.infestation_spawned.connect(_on_infestation_spawned)
		child.infestation_removed.connect(_on_dome_cleansed)
		
		if child == $Domes/Dome:
			child.set_resource_type(Globals.ResourceType.FOOD)
			child.set_sprite("res://art/dome_sprites/Dome_hq_96.png")
			resource_type_array.erase(Globals.ResourceType.FOOD)
		else:
			var random_resource_type = resource_type_array.pop_front()
			child.set_resource_type(random_resource_type)
			
			$UI.action_selected.connect(_on_action_selected)
	
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
	
func _on_control_selected(node: Control):
	if node is SquadInfoDisplay:
		_on_squad_selected(node.squad_link)
		
func _on_action_selected(action: Globals.ActionType):
	selected_action = action
	
func _on_dome_targeted(target_dome: Dome):
	if selected_squad:
		if selected_action == Globals.ActionType.NONE:
			selected_action = Globals.ActionType.FIGHT
		selected_squad.command(selected_action, target_dome)
		
		selected_action = Globals.ActionType.NONE
	Input.set_custom_mouse_cursor(load("res://art/command_sprites/fight_sprite_placeholder.png"), 0, Vector2(12, 12))

func _on_research_toggled(is_enabled: bool):
	for dome in $Domes.get_children():
		dome.toggle_research(is_enabled)

func _on_dome_production_changed(dome: Dome, is_producing: bool):
	if is_producing:
		$UI.add_resource_producer(dome.resource_type, 1)
	else:
		$UI.add_resource_producer(dome.resource_type, -1)
		
func _on_dome_lost(dome: Dome):
	Globals.remaining_domes -= 1
	if dome.resource_type == Globals.ResourceType.RESEARCH:
		Globals.remaining_research_domes -= 1
	
	# If HQ lost, game over. If we hit the dome loss threshold, game over
	if dome == $Domes/Dome || Globals.remaining_research_domes == 0 || Globals.remaining_domes <= Globals.MIN_REMAINING_DOME_THRESHOLD:
		game_over.emit()

func _on_infestation_spawned():
	Globals.infested_domes += 1
	for dome in $Domes.get_children():
		dome.add_infestation_chance_modifier(self, (Globals.BASE_INFESTATION_CHANCE / 1.75 * (1 - float(Globals.infested_domes) / Globals.remaining_domes)))

func _on_dome_cleansed():
	if Globals.infested_domes > 0:
		Globals.infested_domes -= 1
	
	for dome in $Domes.get_children():
		dome.add_infestation_chance_modifier(self, (Globals.BASE_INFESTATION_CHANCE / 1.75 * (1 - float(Globals.infested_domes) / Globals.remaining_domes)))

func _on_ui_main_menu_selected():
	main_menu_selected.emit()
	
func toggle_pause():
	$UI.toggle_pause()
