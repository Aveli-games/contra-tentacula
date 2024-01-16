extends Node

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			$Teams/Team.position = event.position

# this is just for debug, because I don't know how to detect clicks and have no internet!
func _on_team_spawn_timer_timeout():
	# TODO: how to better store the location of the team in data? and display it?
	# maybe assigning this 'location" parameter makes sense, and then Team will display itself at that reference
	$Teams/Team.location = $Domes/Dome2.get_name()
	$Teams/Team.position = $Domes/Dome2.position
