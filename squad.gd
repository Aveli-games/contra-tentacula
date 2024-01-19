extends CharacterBody2D

class_name Squad

signal selected

const BASE_INFESTATION_FIGHT_RATE = -.05
const BASE_MOVE_SPEED = 100 # TODO: Determine best value for this constant

var location: Dome

var target_position: Vector2

func set_sprite(path: String):
	$Sprite2D.texture = load(path)

func _on_area_entered(area):
	location = area
	if location && location.has_method("add_infestation_modifier"):
		# TEMP: Setting to 3x fight rate so single squad can fight back infestation
		location.add_infestation_modifier(BASE_INFESTATION_FIGHT_RATE * 3)

func _on_area_exited(area):
	if location && location.has_method("add_infestation_modifier"):
		# TEMP: Setting to 3x fight rate so single squad can fight back infestation
		location.add_infestation_modifier(-BASE_INFESTATION_FIGHT_RATE * 3)
	
	location = null

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit(self)

func _physics_process(delta):
	if target_position && position.distance_to(target_position) > 3:
		var direction = (target_position - position).normalized()
		velocity = direction * BASE_MOVE_SPEED
		move_and_slide()
