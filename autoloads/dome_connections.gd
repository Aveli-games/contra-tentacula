extends Node

# connections represented as a "directed graph", i.e. each connection is directional
var connections = []
# visual representation of each connection
var line_nodes = []

const INFESTATION_CHANCE_MODIFIER_PREFIX = 'rooted'
const INFESTATION_CHANCE_MODIFIER = 0.10
const ConnectorScene = preload("res://connector_3line.tscn")

func _process(delta):
	for c in connections:
		# increase progress if started
		if c.infestation_progress > 0:
			c.infestation_progress = min(1, c.infestation_progress + Globals.BASE_CONNECTOR_INFESTATION_RATE * delta)
		
		if c.infestation_progress >= 1:
			# this prevents a Safe, occupied dome from being considered instantly cleansed
			if !c.dome_b.is_occupied():
				# TODO can this be called less often? can I check only when progress reaches 1
				c.dome_b.add_infestation_chance_modifier(INFESTATION_CHANCE_MODIFIER_PREFIX + '_' + c.dome_a.get_name(), INFESTATION_CHANCE_MODIFIER)
			
		# sync progress to display nodes
		if c.display.forward:
			c.display.scene_ref.set_forward_progress(c.infestation_progress)
		else:
			c.display.scene_ref.set_reverse_progress(c.infestation_progress)
			
		

# dome_connections: Dome[][]
func instantiate_network(dome_connections, self_ref):
	for pair in dome_connections:
		var dome_1 = pair[0]
		var dome_2 = pair[1]
		if !dome_1 || !dome_2:
			push_error("Null reference provided for Dome connection")
			pass
		var new_connector_scene = connect_domes(dome_1, dome_2)
		self_ref.add_child(new_connector_scene)

# dome_a, dome_b are references to dome nodes
func connect_domes(dome_a: Area2D, dome_b: Area2D):
	var forward_connection = _add_connection(dome_a, dome_b)
	var reverse_connection =_add_connection(dome_b, dome_a)
	
	var connector_scene = draw_connection(forward_connection)
	_attach_connection_display(forward_connection, connector_scene, true)
	_attach_connection_display(reverse_connection, connector_scene, false)
	return connector_scene
	
func _add_connection(dome_a: Area2D, dome_b: Area2D):
	var new_connection = {
		"dome_a": dome_a,
		"dome_b": dome_b,
		"infestation_progress": 0.00,
		"infestation_type": null, # TODO: use types https://github.com/Aveli-games/infestation/issues/17
		# "distance": 100   # could use to determine squad travel time between domes
	}
	connections.append(new_connection)
	return new_connection
	
func _attach_connection_display(connection, scene_ref, forward:bool):
	connection.display = {
			"scene_ref": scene_ref,
			"forward": forward
		}
	
func draw_connection(connection):
	var connector_line = ConnectorScene.instantiate()
	var mainline = connector_line.get_mainline()
	mainline.points[0] = (connection.dome_a.global_position)
	mainline.points[1] = (connection.dome_b.global_position)
	connector_line.z_index=-1
	return connector_line

# get connections that originate from the given dome
func get_dome_connections(dome):
	return connections.filter(func(c): return c.dome_a == dome)

func dome_stop_spread(dome: Dome):
	var connected = get_dome_connections(dome)
	for c in connected:
		c.infestation_progress = 0

func dome_start_spread(dome: Dome, infestation_type = null): 
	var connected = get_dome_connections(dome)
	for c in connected:
		c.infestation_progress = max(Globals.BASE_CONNECTOR_INFESTATION_RATE, c.infestation_progress)
		c.infestation_type = infestation_type  # TODO: use infestation types https://github.com/Aveli-games/infestation/issues/17
