@tool
extends Node2D

func _process(delta):
	var mainline_vector = $MainLine.points[1] - $MainLine.points[0]
	var perpendicular_vector = _get_perpendicular(mainline_vector)
	$ForwardLine.points[0] = $MainLine.points[0] + perpendicular_vector
	$ForwardLine.points[1] = $MainLine.points[1] + perpendicular_vector
	
	$ReverseLine.points[1] = $MainLine.points[0] - perpendicular_vector
	$ReverseLine.points[0] = $MainLine.points[1] - perpendicular_vector
	
func _get_perpendicular(vector: Vector2):
	var vectorAs3d = Vector3(vector.x, vector.y, 0)
	var zUnitVector = Vector3(0,0,1)
	var crossed = vectorAs3d.cross(zUnitVector)
	# TODO: normalize and set our own length
	return Vector2(crossed.x, crossed.y).normalized()*10
