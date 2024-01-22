extends Node

class_name Pather

# start, finish are Domes
# start can be mid-connector
func find_path(start, finish):
	var new_path = [start]
	var connections = DomeConnections.get_dome_connections(start)
	
	for connection in connections:
		var connected_dome = connection.dome_b
		if connected_dome == finish:
			# path found
			return new_path
			
		# check for backtrack
		if connected_dome in new_path:
			return false
			
		# recurse: add dome_b to path, do it again
			
