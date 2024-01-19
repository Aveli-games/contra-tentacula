extends Area2D

class_name Squad

signal selected

const BASE_INFESTATION_FIGHT_RATE = -.05
const BASE_MOVE_SPEED = 100 # TODO: Determine best value for this constant

var location: Dome

var target_position: Vector2
var velocity = Vector2.ZERO

func set_sprite(path: String):
	$Sprite2D.texture = load(path)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit(self)

func _physics_process(delta):
	if target_position && position.distance_to(target_position) > 3:
		var direction = (target_position - position).normalized()
		velocity = direction * BASE_MOVE_SPEED
		position += velocity * delta

# TODO: Update this with respective squad actions
func _on_area_entered(area: Dome):
		area.add_infestation_modifier(BASE_INFESTATION_FIGHT_RATE * 3)
		location = area
		position = location.position

# TODO: Update this with respective squad actions
func _on_area_exited(area: Dome):
		area.add_infestation_modifier(-BASE_INFESTATION_FIGHT_RATE * 3)
		location = null
