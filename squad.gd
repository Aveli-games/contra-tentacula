extends Area2D

class_name Squad

signal selected
signal movement_completed
signal movement_started

var BASE_INFESTATION_FIGHT_RATE = -Globals.BASE_DOME_INFESTATION_RATE
var BASE_MOVE_SPEED = 100 # TODO: Determine best value for this constant

var target_location: Dome
var location: Dome
var slot: BuildingSlot
var squad_type: Globals.SquadType = Globals.SquadType.NONE
var display_link: SquadInfoDisplay
var mouseover: bool = false
var is_selected: bool = false

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

func set_sprite(path: String):
	$Sprite2D.texture = load(path)
	
func set_type(type: Globals.SquadType):
	squad_type = type
	match squad_type:
		Globals.SquadType.SCIENTIST:
			set_sprite("res://art/squad_sprites/GasMaskScientist_128.png")
		Globals.SquadType.PYRO:
			set_sprite("res://art/squad_sprites/GasmaskPyro_128.png")
		Globals.SquadType.BOTANIST:
			set_sprite("res://art/squad_sprites/GasmaskBot_128.png")
		Globals.SquadType.ENGINEER:
			set_sprite("res://art/squad_sprites/GasmaskSanitation_128.png")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit(self)

func _physics_process(delta):
	if target_position && global_position.distance_to(target_position) > 3:
		var direction = (target_position - global_position).normalized()
		velocity = direction * BASE_MOVE_SPEED
		global_position += velocity * delta
	elif velocity != Vector2.ZERO:
		velocity = Vector2.ZERO
		
		if target_location != location:
			movement_completed.emit()

# TODO: Update this with respective squad actions
func _on_movement_completed():
	if target_location:
		target_location.enter(self)
		moving = false
		_start_next_action()

func _on_movement_started():
	if location:
		location = null
		moving = true
	
# Returns true if valid move target, false if not
func move(target: Dome):
	if moving: # We are moving, no moving action allowed
		return false
	if !location: # We don't have a current location, move to get one
		print_debug("We don't have a current location, move to target: ", target)
		_set_action_queue([_create_action(Globals.ActionType.MOVE, target)])
		return true
	if location == target: # Target is current location ==> already there?
		return true
	
	var pather = Pather.new()
	var path_to_target = pather.find_path(location, target)
	if path_to_target:
		# dome/slot management
		global_position = location.global_position
		if slot:
			slot.empty(self)
			
		# movement
		# fill action queue with move actions
		# first element is current location
		path_to_target.pop_front()
		print('PATH: ', path_to_target)
		var move_actions = path_to_target.map(_create_move_action)
		_set_action_queue(move_actions)
		return true
	else: # Target is not connected to current location
		return false
		
func _create_action(type: Globals.ActionType, target: Dome):
	print_debug('action created: ', {'type': type, 'target': target})
	return {'type': type, 'target': target}
	
func _create_move_action(target: Dome):
	return _create_action(Globals.ActionType.MOVE, target)
	
func special(target: Dome):
	if location:
		if Globals.resources[Globals.ResourceType.FOOD] >= 2:
			Globals.add_resource(Globals.ResourceType.FOOD, -2)
			location.add_infestation(BASE_INFESTATION_FIGHT_RATE * 2 * $ActionTimer.wait_time)
		else:
			fight(target)

func fight(target: Dome):
	if location:
		if Globals.resources[Globals.ResourceType.FOOD] >= 1:
			Globals.add_resource(Globals.ResourceType.FOOD, -1)
			location.add_infestation(BASE_INFESTATION_FIGHT_RATE * $ActionTimer.wait_time)

# called on right-click from main.gd
func command(action: Globals.ActionType, target: Dome):
	if move(target):
		if display_link:
			display_link.set_action(action)

func set_target(target: Dome):
	target_position = target.global_position
	target_location = target
	movement_started.emit()

func set_highlight(is_enable: bool):
	is_selected = is_enable
	$Sprite2D.material.set_shader_parameter("line_color", Color.YELLOW)
	$Sprite2D.material.set_shader_parameter("on", is_enable)
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
		match current_action:
			Globals.ActionType.SPECIAL:
				special(target_location)
			Globals.ActionType.FIGHT:
				fight(target_location)
