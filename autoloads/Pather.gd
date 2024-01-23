extends Node

class_name Pather

# start, finish are Domes
##TODO: make it so start can be mid-connector, for canceling movement
func find_path(start: Dome, finish: Dome):
	# if start is connection
	# new path = []
	# connections = [start.dome_a, start.dome_b]
	# does this break backtrack checking?
	
	var working_paths = [[start]]
	var visited = {start.get_name(): 1} # is there a Set?

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
				print('backtrack path: ', continued_path)
				pass
			
			if connected_dome.name in visited.keys():
				print('already visited dome: ', continued_path)
				pass
			
			visited[connected_dome.name] = 1
			working_paths.append(continued_path)
			
	return false
