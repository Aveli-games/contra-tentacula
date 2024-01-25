extends Area2D

class_name Squad

signal selected
signal movement_completed
signal movement_started
signal research_toggled

var SCIENTIST_PASSIVE_RATE_MODIFIER = -.5
var target_location: Dome
var location: Dome
var slot: BuildingSlot
var squad_type: Globals.SquadType = Globals.SquadType.NONE
var display_link: SquadInfoDisplay
var mouseover: bool = false
var is_selected: bool = false
var researching: bool = false

var target_position: Vector2
var velocity: Vector2 = Vector2.ZERO
var current_action = {'type': Globals.ActionType.NONE}
var action_queue = []

var moving: bool = false

func _ready():
	set_highlight(false)
	
# call when queue changes or action finished
func _start_next_action():
	var next_action = action_queue.pop_front()
	if next_action:
		print_debug(self.name, next_action)
		current_action = next_action
		if current_action.type == Globals.ActionType.MOVE:
			set_target(current_action.target)
		
func _set_action_queue(new_queue):
	action_queue = new_queue
	print('action_queue: ', action_queue)
	_start_next_action()
	
func _add_to_action_queue(new_action):
	var queue_empty = action_queue.size() == 0
	action_queue.append(new_action)
	if queue_empty:
		_start_next_action()

func set_sprite(path: String):
	$Sprite2D.texture = load(path)
	
func set_type(type: Globals.SquadType):
	squad_type = type
	match squad_type:
		Globals.SquadType.SCIENTIST:
			set_sprite("res://art/squad_sprites/GasMaskScientist_128.png")
			$VoiceLines/MoveVoice.stream = load("res://sfx/scientist_voice.tres")
			$VoiceLines/SelectVoice.stream = load("res://sfx/voice lines/scientist/sci blast off.wav")
			$VoiceLines/FightVoice.stream = load("res://sfx/scientist_fight.tres")
			$VoiceLines/SpecialVoice.stream = load("res://sfx/scientist_special.tres")
		Globals.SquadType.PYRO:
			set_sprite("res://art/squad_sprites/GasmaskPyro_128.png")
			$VoiceLines/MoveVoice.stream = load("res://sfx/pyro_voice.tres")
			$VoiceLines/SelectVoice.stream = load("res://sfx/voice lines/pyro/pyro gotta light.wav")
			$VoiceLines/FightVoice.stream = load("res://sfx/pyro_fight.tres")
			$VoiceLines/SpecialVoice.stream = load("res://sfx/pyro_special.tres")
		Globals.SquadType.BOTANIST:
			set_sprite("res://art/squad_sprites/GasmaskBot_128.png")
			$VoiceLines/MoveVoice.stream = load("res://sfx/botanist_voice.tres")
			$VoiceLines/SelectVoice.stream = load("res://sfx/voice lines/botanist/bot chop chop.wav")
			$VoiceLines/FightVoice.stream = load("res://sfx/botanist_fight.tres")
			$VoiceLines/SpecialVoice.stream = load("res://sfx/botanist_special.tres")
		Globals.SquadType.ENGINEER:
			set_sprite("res://art/squad_sprites/GasmaskSanitation_128.png")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit(self)

func _input(event):
	match squad_type:
		Globals.SquadType.SCIENTIST:
			if event.is_action_pressed("Squad1"):
				selected.emit(self)
		Globals.SquadType.PYRO:
			if event.is_action_pressed("Squad2"):
				selected.emit(self)
		Globals.SquadType.BOTANIST:
			if event.is_action_pressed("Squad3"):
				selected.emit(self)
		Globals.SquadType.ENGINEER:
			if event.is_action_pressed("Squad4"):
				selected.emit(self)

func _physics_process(delta):
	if target_position && global_position.distance_to(target_position) > 3:
		var direction = (target_position - global_position).normalized()
		velocity = direction * Globals.BASE_MOVE_SPEED
		global_position += velocity * delta
	elif velocity != Vector2.ZERO:
		velocity = Vector2.ZERO
		
		if target_location != location:
			movement_completed.emit()

func _on_movement_completed():
	if target_location:
		target_location.enter(self)
		moving = false
		apply_passive(location)
		_start_next_action()

func _on_movement_started():
	if location:
		remove_passive(location)
		location = null
		moving = true
	
# Returns true if valid move target, false if not
func move(target: Dome):
	var pather_args = {}
	if moving: # We are moving
		# find paths starting with current movement segment and its reverse
		if current_action.has('from') && current_action.has('to'):
			pather_args.start_paths = [[current_action.from, current_action.to],[current_action.to, current_action.from]]
		else:
			return false
	elif !location: # We don't have a current location, move to get one
		print_debug("We don't have a current location, move to target: ", target)
		_set_action_queue([_create_action(Globals.ActionType.MOVE, target)])
		return true
	elif location == target: # Target is current location ==> already there?
		return true
	else:
		pather_args['start_dome'] = location
	
	var pather = Pather.new()
	var path_to_target = pather.find_path(target, pather_args)
	if path_to_target:
		# dome/slot management
		global_position = location.global_position
		if slot:
			slot.empty(self)
			
		# movement
		# fill action queue with move actions
		# first element is current location
		print('PATH: ', path_to_target)
		var move_actions = []
		for i in path_to_target.size() - 1:
			var from: Dome = path_to_target[i]
			var to: Dome = path_to_target[i+1]
			move_actions.append(_create_move_action(to, from))
				
		_set_action_queue(move_actions)
		return true
	else: # Target is not connected to current location
		return false
		
func _create_action(type: Globals.ActionType, target: Dome = null, from: Dome = null):
	print_debug('action created: ', {'type': type, 'target': target, 'from': from})
	return {'type': type, 'target': target, 'from': from}
	
func _create_move_action(target: Dome, from: Dome):
	return _create_action(Globals.ActionType.MOVE, target, from)
	
func special(target: Dome):
	if location && location == target:
		match squad_type:
			Globals.SquadType.NONE, Globals.SquadType.BOTANIST:
				if Globals.resources[Globals.ResourceType.FOOD] >= 2:
					Globals.add_resource(Globals.ResourceType.FOOD, -2)
					location.add_infestation(Globals.BASE_INFESTATION_FIGHT_RATE * 4 * $ActionTimer.wait_time)
				else:
					fight(target)
			Globals.SquadType.PYRO:
				if Globals.resources[Globals.ResourceType.FOOD] >= 1 &&  Globals.resources[Globals.ResourceType.FUEL] >= abs(Globals.PYRO_SPECIAL_FUEL_USAGE):
					Globals.add_resource(Globals.ResourceType.FOOD, -1)
					Globals.add_resource(Globals.ResourceType.FUEL, Globals.PYRO_SPECIAL_FUEL_USAGE)
					location.add_infestation(Globals.BASE_INFESTATION_FIGHT_RATE * 4 * $ActionTimer.wait_time)
				else:
					fight(target)
			Globals.SquadType.ENGINEER:
				if Globals.resources[Globals.ResourceType.FOOD] >= 1 &&  Globals.resources[Globals.ResourceType.PARTS] >= abs(Globals.ENGI_SPECIAL_PARTS_USAGE):
					Globals.add_resource(Globals.ResourceType.FOOD, -1)
					Globals.add_resource(Globals.ResourceType.PARTS, Globals.ENGI_SPECIAL_PARTS_USAGE)
					location.add_infestation(Globals.BASE_INFESTATION_FIGHT_RATE * 4 * $ActionTimer.wait_time)
				else:
					fight(target)
			Globals.SquadType.SCIENTIST:
				var old_state = researching
				var new_state = true
				
				for squad in location.present_squads:
					if squad.squad_type != Globals.SquadType.SCIENTIST:
						if squad.current_action.type > Globals.ActionType.MOVE:
							new_state = false
							break
							
				if old_state != new_state: # I.e. state has changed
					toggle_research(new_state)
	else:
		if squad_type == Globals.SquadType.SCIENTIST:
			toggle_research(false)

func fight(target: Dome):
	if location && location == target:
		location.add_infestation(Globals.BASE_INFESTATION_FIGHT_RATE * $ActionTimer.wait_time)

# called on right-click from main.gd
func command(action: Globals.ActionType, target: Dome):
	print_debug('command issued: ', action, target)
	if move(target):
		match action:
			Globals.ActionType.MOVE:
				_talk($VoiceLines/MoveVoice)
			Globals.ActionType.SPECIAL:
				_talk($VoiceLines/SpecialVoice)
			Globals.ActionType.FIGHT:
				_talk($VoiceLines/FightVoice)
		# Cancel current research toggle if not scientist special at current location
		if squad_type == Globals.SquadType.SCIENTIST && (location != target || action != Globals.ActionType.SPECIAL):
			toggle_research(false)
		_add_to_action_queue(_create_action(action, target))
		if display_link:
			display_link.set_action(action)
			
func apply_passive(target: Dome):
	if location:
		match squad_type:
			Globals.SquadType.SCIENTIST:
				location.add_infestation_rate_modifier(self.get_instance_id(), SCIENTIST_PASSIVE_RATE_MODIFIER)

func remove_passive(target: Dome):
	if location:
		match squad_type:
			Globals.SquadType.SCIENTIST:
				location.remove_infestation_rate_modifier(self.get_instance_id())

func toggle_research(is_enable: bool):
	if is_enable != researching:
		researching = is_enable
		research_toggled.emit(researching)

func set_target(target: Dome):
	target_position = target.global_position
	target_location = target
	movement_started.emit()

func set_highlight(is_enable: bool):
	is_selected = is_enable
	$Sprite2D.material.set_shader_parameter("line_color", Color.YELLOW)
	$Sprite2D.material.set_shader_parameter("on", is_enable)
	if is_selected:
		_talk($VoiceLines/SelectVoice)
	if display_link:
		display_link.set_highlight(is_enable)

func set_mouseover():
	if mouseover && not is_selected:
		$Sprite2D.material.set_shader_parameter("line_color", Color.CYAN)
		$Sprite2D.material.set_shader_parameter("on", mouseover)
	elif is_selected:
		$Sprite2D.material.set_shader_parameter("line_color", Color.YELLOW)
		$Sprite2D.material.set_shader_parameter("on", true)
	else:
		$Sprite2D.material.set_shader_parameter("on", mouseover)
	
func _on_mouse_entered():
	mouseover = true
	set_mouseover()

func _on_mouse_exited():
	mouseover = false
	set_mouseover()

func _on_action_timer_timeout():
	if target_location == location && location.infestation_percentage > 0 && location.infestation_stage != Globals.InfestationStage.LOST:
		match current_action.type:
			Globals.ActionType.SPECIAL:
				special(target_location)
			Globals.ActionType.FIGHT:
				fight(target_location)

func _talk(audio: AudioStreamPlayer):
	for player in $VoiceLines.get_children():
		if player.get_playback_position() > 0:
			return
	if audio && not AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX")):
		audio.play()
		
	
