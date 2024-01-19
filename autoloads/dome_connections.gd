extends Node

# connections represented as a "directed graph", i.e. each connection is directional
var connections = []
# visual representation of each connection
var line_nodes = []


func _process(delta):
	for c in connections:
		if c.infestation_progress > 0:
			c.infestation_progress += Globals.BASE_CONNECTOR_INFESTATION_RATE * delta
		if c.infestation_progress > 1 && c.dome_b.infestation_percentage == 0:
			c.dome_b.add_infestation(Globals.base_infestation_rate * delta)
			print('CONNECTOR: spread infestation to ', c.dome_b.get_name())
		

# dome_connections: Area2D[][]
func instantiate_network(dome_connections, self_ref):
	for pair in dome_connections:
		var dome_1 = pair[0]
		var dome_2 = pair[1]
		if !dome_1 || !dome_2:
			push_error("Null reference provided for Dome connection")
			pass
		DomeConnections.connect_domes(dome_1, dome_2)
	
	var new_line_nodes = DomeConnections.draw_connections()
	for i in new_line_nodes:
		self_ref.add_child(i)

# dome_a, dome_b are references to dome nodes
func connect_domes(dome_a: Area2D, dome_b: Area2D):
	_add_connection(dome_a, dome_b)
	_add_connection(dome_b, dome_a)
	
func _add_connection(dome_a: Area2D, dome_b: Area2D):
	var new_connection = {
		"dome_a": dome_a,
		"dome_b": dome_b,
		"infestation_progress": 0.00,
		"infestation_type": null, # TODO: use types https://github.com/Aveli-games/infestation/issues/17
		# "distance": 100   # could use to determine squad travel time between domes
	}
	connections.append(new_connection)
	
func draw_connections():
	for i in connections:
		var line = Line2D.new()
		line.add_point(i.dome_a.global_position)
		line.add_point(i.dome_b.global_position)
		line.z_index=-1
		# TODO: get proper texture
		line.texture = load("res://art/squad_sprites/botanist_icon_placeholder.png")
		line.texture_mode = Line2D.LINE_TEXTURE_TILE
		line.texture_repeat = Line2D.TEXTURE_REPEAT_ENABLED
		line_nodes.append(line)
	return line_nodes

func get_dome_connections(dome):
	return connections.filter(func(c): return c.dome_a == dome)

func dome_stop_spread(dome: Area2D):
	var connected = get_dome_connections(dome)
	for c in connected:
		c.infestation_progress = 0

func dome_start_spread(dome: Area2D, infestation_type = null): 
	var connected = get_dome_connections(dome)
	for c in connected:
		c.infestation_progress = Globals.BASE_CONNECTOR_INFESTATION_RATE
		c.infestation_type = infestation_type  # TODO: use infestation types https://github.com/Aveli-games/infestation/issues/17
