extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for d in [$Dome2, $Dome3, $Dome4, $Dome5]:
		DomeConnections.connect_domes($Dome, d)
	var line_nodes = DomeConnections.draw_connections()
	for i in line_nodes:
		add_child(i)
		
	Globals.BASE_CONNECTOR_INFESTATION_RATE = 0.5
	DomeConnections.dome_start_spread($Dome5)
