extends Area2D

class_name Squad

signal selected
signal movement_completed
signal movement_started
signal research_toggled

var BASE_INFESTATION_FIGHT_RATE = -Globals.BASE_DOME_INFESTATION_RATE
var BASE_MOVE_SPEED = 100 # TODO: Determine best value for this
var SCIENTIST_PASSIVE_RATE_MODIFIER = -.075

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

func _on_movement_completed():
	if target_location:
		target_location.enter(self)
		moving = false
		apply_passive(location)

func _on_movement_started():
	if location:
		remove_passive(location)
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

func special(target: Dome):
	if location && location == target:
		match squad_type:
			Globals.SquadType.NONE, Globals.SquadType.BOTANIST:
				if Globals.resources[Globals.ResourceType.FOOD] >= 2:
					Globals.add_resource(Globals.ResourceType.FOOD, -2)
					location.add_infestation(BASE_INFESTATION_FIGHT_RATE * 2 * $ActionTimer.wait_time)
				else:
					fight(target)
			Globals.SquadType.PYRO:
				if Globals.resources[Globals.ResourceType.FOOD] >= 1 &&  Globals.resources[Globals.ResourceType.FUEL] >= 1:
					Globals.add_resource(Globals.ResourceType.FOOD, -1)
					Globals.add_resource(Globals.ResourceType.FUEL, -1)
					location.add_infestation(BASE_INFESTATION_FIGHT_RATE * 2 * $ActionTimer.wait_time)
				else:
					fight(target)
			Globals.SquadType.ENGINEER:
				if Globals.resources[Globals.ResourceType.FOOD] >= 1 &&  Globals.resources[Globals.ResourceType.PARTS] >= 1:
					Globals.add_resource(Globals.ResourceType.FOOD, -1)
					Globals.add_resource(Globals.ResourceType.PARTS, -1)
					location.add_infestation(BASE_INFESTATION_FIGHT_RATE * 2 * $ActionTimer.wait_time)
				else:
					fight(target)
			Globals.SquadType.SCIENTIST:
				var old_state = researching
				var new_state = true
				
				for squad in location.present_squads:
					if squad.squad_type != Globals.SquadType.SCIENTIST:
						if squad.current_action > Globals.ActionType.MOVE:
							new_state = false
							break
							
				if old_state != new_state: # I.e. state has changed
					toggle_research(new_state)
	else:
		if squad_type == Globals.SquadType.SCIENTIST:
			toggle_research(false)

func fight(target: Dome):
	if location && location == target:
		if Globals.resources[Globals.ResourceType.FOOD] >= 1:
			Globals.add_resource(Globals.ResourceType.FOOD, -1)
			location.add_infestation(BASE_INFESTATION_FIGHT_RATE * $ActionTimer.wait_time)

func command(action: Globals.ActionType, target: Dome):
	if move(target):
		current_action = action
		if squad_type == Globals.SquadType.SCIENTIST && current_action != Globals.ActionType.SPECIAL:
			toggle_research(false)
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
