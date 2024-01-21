extends Node2D

func _ready():
	## set offset to length as well, so it's at the bottom
	#$ProgressBar.pivot_offset.x = $ProgressBar.size.x/2
	#$ProgressBar.pivot_offset.y = get_line_length()
	
	print($ConnectorInfestation.points)
	# how to set position of bottom middle?
	#$ProgressBar.set_global_position($ConnectorInfestation.points[0] )
	print($ProgressBar.position)
	print($ProgressBar.global_position)
	# set size.y to length of line
	#$ProgressBar.size.y = get_line_length()
	

	#
	#var line_angle = get_rotation_angle()
	#print(line_angle * 180 / PI)
	#$ProgressBar.rotation = line_angle
	
func get_rotation_angle():
	# add 90deg because angle() is relative to +x axis
	# rotation is relative to y axis
	return ($ConnectorInfestation.points[1] - $ConnectorInfestation.points[0]).angle() + (PI/2)
	
func get_line_length():
	return ($ConnectorInfestation.points[1] - $ConnectorInfestation.points[0]).length()
