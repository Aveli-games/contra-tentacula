extends Node

const BASE_INFESTATION_RATE = 0.05
const BASE_INFESTATION_CHANCE_PER_TICK = 0.05

# TODO: I think everything should run on delta or a 1s tick, _process runs much more often
func _process(delta):
	for child in $Domes.get_children():
		if child.get_name() == $Team.location:
			print(child.infestation_percentage)
			child.add_infestation(-0.01)
		if randf() < BASE_INFESTATION_CHANCE_PER_TICK:
			# modify infestation rate here
			child.add_infestation(BASE_INFESTATION_RATE)
			

# this is just for debug, because I don't know how to detect clicks and have no internet!
func _on_team_spawn_timer_timeout():
	# TODO: how to better store the location of the team in data? and display it?
	# maybe assigning this 'location" parameter makes sense, and then Team will display itself at that reference
	$Team.location = $Domes/Dome2.get_name()
	$Team.position = $Domes/Dome2.position

