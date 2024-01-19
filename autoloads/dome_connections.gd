extends Node

# connections represented as a "directed graph", i.e. each connection is directional
var connections = []
# visual representation of each connection
# https://github.com/Aveli-games/infestation/issues/11
# TODO: how to texture programmatically? or can we texture a scene and instantiate that programatically?
var line_nodes = []


func _process(delta):
	for c in connections:
		if c.infestation_progress > 0:
			c.infestation_progress += Globals.BASE_CONNECTOR_INFESTATION_RATE * delta
		if c.infestation_progress > 1 && c.b.infestation_percentage == 0:
			c.b.add_infestation(Globals.base_infestation_rate * delta)
			print('CONNECTOR: spread infestation to ', c.b.get_name())
		

# dome_connections: Area2D[][]
func instantiate_network(dome_connections, self_ref):
	for pair in dome_connections:
		var dome_1 = pair[0]
		var dome_2 = pair[1]
		if !dome_1 || !dome_2:
			push_error("Null reference provided for Dome connection")
			pass
		DomeConnections.connect_domes(dome_1, dome_2)
	
	var line_nodes = DomeConnections.draw_connections()
	for i in line_nodes:
		self_ref.add_child(i)

# dome_a, dome_b are references to dome nodes
func connect_domes(dome_a: Area2D, dome_b: Area2D):
	_add_connection(dome_a, dome_b)
	_add_connection(dome_b, dome_a)
	
func _add_connection(dome_a: Area2D, dome_b: Area2D):
	var new_connection = {
		"a": dome_a,
		"b": dome_b,
		"infestation_progress": 0.00,
		"infestation_type": null, # TODO: use types https://github.com/Aveli-games/infestation/issues/17
		# "distance": 100   # could use to determine squad travel time between domes
	}
	connections.append(new_connection)
	dome_a.connections.append(dome_b)
	
func draw_connections():
	for i in connections:
		var line = Line2D.new()
		line.add_point(i.a.global_position)
		line.add_point(i.b.global_position)
		line.default_color = Color(1,1,1,0.2)
		line_nodes.append(line)
	return line_nodes

func get_dome_connections(dome):
	return connections.filter(func(c): return c.a == dome)

func dome_stop_spread(dome: Area2D):
	var connected = get_dome_connections(dome)
	for c in connected:
		c.infestation_progress = 0

func dome_start_spread(dome: Area2D, infestation_type = null): 
	var connected = get_dome_connections(dome)
	for c in connected:
		c.infestation_progress = Globals.BASE_CONNECTOR_INFESTATION_RATE
		c.infestation_type = infestation_type  # TODO: use infestation types https://github.com/Aveli-games/infestation/issues/17
