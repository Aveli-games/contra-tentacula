extends Line2D

@export var shadowed_line: Line2D

func attach_line(line):
	shadowed_line = line
	# offset using orthogonal vector, distance = shadowed_line.width/2

func set_progress(progress):
	# set 2nd point based on desired length and %
	# is there a vector scaling fn?
	pass

func get_line_angle():
	# add 90deg because angle() is relative to +x axis
	# rotation is relative to y axis
	return (shadowed_line.points[1] - shadowed_line.points[0]).angle() + (PI/2)
	
func get_line_length():
	return (shadowed_line.points[1] - shadowed_line.points[0]).length()
