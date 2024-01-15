extends Node2D

signal selected

const INFESTATION_FIGHT_RATE = -.05

var location: Area2D

func _process(delta):
	if location && location.has_method("add_infestation"):
		# TEMP: Setting to 3x fight rate so single squad can fight back infestation
		location.add_infestation(INFESTATION_FIGHT_RATE * 3 * delta)

func _on_area_entered(area):
	location = area

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit(self)
