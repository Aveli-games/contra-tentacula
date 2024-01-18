extends Node

# connections represented as a "directed graph", i.e. each connection is directional
var connections = []
# visual representation of each connection
var line_nodes = []

# dome_a, dome_b are references to dome nodes
func connect_domes(dome_a: Area2D, dome_b: Area2D):
	_add_connection(dome_a, dome_b)
	_add_connection(dome_b, dome_a)
	
func _add_connection(dome_a: Area2D, dome_b: Area2D):
	var new_connection = {
		"a": dome_a,
		"b": dome_b,
		"infestation_progress": 0.00,
		"infestation_type": null, # TODO: use types
		# "distance": 100   # could use to determine squad travel time between domes
	}
	connections.append(new_connection)
	
func draw_connections():
	for i in connections:
		var line = Line2D.new()
		line.add_point(i.a.global_position)
		line.add_point(i.b.global_position)
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
		c.infestation_type = infestation_type  # TODO: use infestation types

