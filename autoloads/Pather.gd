extends Node

class_name Pather

# finish:
#   Dome you want to path to
# params:
#   `start_dome`, which is a single dome to start from
#   OR `start_paths`: Dome[][], which are path segments to continue searching from
func find_path(finish: Dome, params = {}):
	var working_paths = []
	var visited = {}
	if params.has('start_dome'):
		working_paths.append([params.start_dome])
	elif params.has('start_paths'):
		working_paths = params.start_paths.duplicate()
	else: 
		push_error('No start parameters provided for pathing')
		return []

	# treat all provided domes as visited for algorithm
	for path in working_paths:
		for dome in path:
			visited[dome.get_name()] = 1

	while working_paths.size() > 0:
		var path_base = working_paths.pop_front()
		# check connections, extend paths
		var dome_from = path_base[-1]
		var connections = DomeConnections.get_dome_connections(dome_from)

		for connection in connections:
			var connected_dome = connection.dome_b
			var continued_path = path_base.duplicate(true)
			continued_path.append(connected_dome)
			
			# path complete
			if connected_dome == finish:
				return continued_path
			
			# check for backtrack
			if connected_dome in path_base:
				#print('backtrack path: ', continued_path)
				continue
			
			if connected_dome.name in visited.keys():
				#print('already visited dome: ', continued_path)
				continue
			
			visited[connected_dome.name] = 1
			working_paths.append(continued_path)
			
	return false
