extends Node

var selected_squad

func _ready():
	for child in $Squads.get_children():
		child.location = $Domes/Dome
		child.selected.connect(_on_squad_selected)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and selected_squad:
			selected_squad.position = event.position

func _on_squad_selected(squad_node):
	selected_squad = squad_node
