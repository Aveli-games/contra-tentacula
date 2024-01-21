@tool
extends Node2D

@export var tool_forward = 0

var forward_progress = 0
var reverse_progress = 0

const ADD_ANIMATION_SPEED = 1
const REMOVE_ANIMATION_SPEED = 2 * ADD_ANIMATION_SPEED

func _ready():
	if not Engine.is_editor_hint():
		set_forward_progress(0)
		_set_reverse_length(0)
		set_reverse_progress(0)

func _process(delta):
	if Engine.is_editor_hint():
		set_forward_progress(tool_forward)
		tool_forward += delta * 0.2
		if tool_forward > 1:
			tool_forward = 0
		set_reverse_progress(0.75)
		
	# interpolate between progress and display length every tick, to smooth changes
	var reverse_display_progress = _get_reverse_display_progress()
	var reverse_diff = reverse_progress - reverse_display_progress
	var reverse_adjustment = min(reverse_diff, REMOVE_ANIMATION_SPEED * delta)
	_set_reverse_length(reverse_display_progress + reverse_adjustment)
	
func get_progress_line(percent: float, forward: bool):
	var new_length = get_mainline_length() * percent
	var perpendicular_vector = _get_perpendicular(get_mainline_vector())
	var normalized_vector = get_mainline_vector().normalized() * (1 if forward else -1)
	var start_point = $MainLine.points[0] if forward else $MainLine.points[1] #+ perpendicular_vector
	var new_end_point = start_point + normalized_vector * new_length #+ perpendicular_vector
	
	return [start_point, new_end_point]

# TODO: make identical change for forward direction
func set_reverse_progress(percent):
	reverse_progress = percent

func _set_reverse_length(percent):
	var perpendicular_vector = _get_perpendicular(get_mainline_vector())
	var new_backward = get_progress_line(percent, false)
	$ReverseLine.points[0] = new_backward[0] - perpendicular_vector
	$ReverseLine.points[1] = new_backward[1] - perpendicular_vector
	
func _get_reverse_display_progress():
	var mainline_length = get_mainline_length()
	var reverse_length = ($ReverseLine.points[1] - $ReverseLine.points[0]).length()
	return reverse_length / mainline_length

func set_forward_progress(percent):
	var perpendicular_vector = _get_perpendicular(get_mainline_vector())
	var new_forward = get_progress_line(percent, true)

	$ForwardLine.points[0] = new_forward[0] + perpendicular_vector
	$ForwardLine.points[1] = new_forward[1] + perpendicular_vector
	

func get_mainline_vector():
	return $MainLine.points[1] - $MainLine.points[0]

func get_mainline_length():
	return get_mainline_vector().length()

func _get_perpendicular(vector: Vector2):
	var vectorAs3d = Vector3(vector.x, vector.y, 0)
	var zUnitVector = Vector3(0,0,1)
	var crossed = vectorAs3d.cross(zUnitVector)
	# TODO: normalize and set our own length
	return Vector2(crossed.x, crossed.y).normalized()*5
	
func get_mainline():
	return $MainLine
