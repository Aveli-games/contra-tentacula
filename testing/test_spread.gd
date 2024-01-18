extends Node2D


func _ready():
	var dome_connections = [
		[$Dome, $Dome2],
		[$Dome, $Dome3],
		[$Dome, $Dome4],
		[$Dome, $Dome5],
		[$Dome5, $Dome6],
	]

	DomeConnections.instantiate_network(dome_connections, self)
		
	#DomeConnections.dome_start_spread($Dome5)
	$Dome5.add_infestation(0.9)