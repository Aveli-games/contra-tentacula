extends Area2D

class_name Squad

signal selected
signal movement_completed
signal movement_started

var BASE_INFESTATION_FIGHT_RATE = -Globals.BASE_DOME_INFESTATION_RATE / 2
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
var current_action: Globals.ActionType = Globals.ActionType.NONE

var moving: bool = false

func _ready():
	set_highlight(false)

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

func _on_movement_started():
	if location:
		location = null
		moving = true
	
# Returns true if valid move target, false if not
func move(target: Dome):
	if not moving:
		if location:
			if location != target:
				var location_connections = location.get_connections()
				if location != target && location_connections.find(target) != -1:
					global_position = location.global_position
					if slot:
						slot.empty(self)
					set_target(target)
					return true
				else: # Target is not connected to current location
					return false
			else: # Target is current location
				return true
		else: # We don't have a current location, move to get one
			set_target(target)
			return true
	else: # We are moving, no moving action allowed
		return false

func special():
	if location:
		location.add_infestation_rate_modifier(self.get_instance_id(), 3 * BASE_INFESTATION_FIGHT_RATE)

func fight():
	if location:
		location.add_infestation_rate_modifier(self.get_instance_id(), BASE_INFESTATION_FIGHT_RATE)

func command_move(target: Dome):
	if move(target):
		current_action = Globals.ActionType.MOVE
		if display_link:
			display_link.set_action(Globals.ActionType.MOVE)

func command_special(target: Dome):
	if move(target):
		current_action = Globals.ActionType.SPECIAL
		if display_link:
			display_link.set_action(Globals.ActionType.SPECIAL)
		
		if moving:
			await movement_completed
		
		special()

func command_fight(target: Dome):
	if move(target):
		current_action = Globals.ActionType.FIGHT
		if display_link:
			display_link.set_action(Globals.ActionType.FIGHT)
		
		if moving:
			await movement_completed
		
		fight()

func command(action: Globals.ActionType, target: Dome):
	# Cancel any current modifier
	if location:
		location.remove_infestation_rate_modifier(self.get_instance_id())
	
	match action:
		Globals.ActionType.NONE:
			command_fight(target)
		Globals.ActionType.MOVE:
			command_move(target)
		Globals.ActionType.SPECIAL:
			command_special(target)
		Globals.ActionType.FIGHT:
			command_fight(target)

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
