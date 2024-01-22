extends Node

class_name Pather

# start, finish are Domes
# start can be mid-connector
func find_path(start, finish):
	# if start is connection
	# new path = []
	# connections = [start.dome_a, start.dome_b]
	# does this break backtrack checking?
	
	var new_path = [start]
	return continue_path(new_path, finish)

func continue_path(path_array, finish):
	var dome_from = path_array[-1]
	var connections = DomeConnections.get_dome_connections(dome_from)

	for connection in connections:
		var connected_dome = connection.dome_b
		var continued_path = path_array.duplicate(true).push(connected_dome)
		
		if connected_dome == finish:
			# path found
			return continued_path
			
		# check for backtrack
		if connected_dome in path_array:
			print('dead end path: ', continued_path)
			return false
			
		# recurse: with dome_b added to path, do it again
		var found_path = continue_path(continued_path, finish) 
		if found_path:
			return found_path
	

