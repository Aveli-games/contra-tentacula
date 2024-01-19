extends Area2D

class_name Squad

signal selected
signal movement_completed
signal movement_started

const BASE_INFESTATION_FIGHT_RATE = -.05
const BASE_MOVE_SPEED = 100 # TODO: Determine best value for this constant

var target_location: Dome
var location: Dome
var slot: BuildingSlot
var squad_type: Globals.SquadType = Globals.SquadType.NONE
var display_link: SquadInfoDisplay

var target_position: Vector2
var velocity: Vector2 = Vector2.ZERO

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
		target_location.add_infestation_modifier(BASE_INFESTATION_FIGHT_RATE * 3)
		moving = false

# TODO: Update this with respective squad actions
func _on_movement_started():
	if location:
		location.add_infestation_modifier(-BASE_INFESTATION_FIGHT_RATE * 3)
		location = null
		moving = true
	
func move(target: Dome):
	if not moving:
		if location:
			var location_connections = location.get_connections()
			if location != target && location_connections.find(target) != -1:
				global_position = location.global_position
				if slot:
					slot.empty(self)
				set_target(target)
		else:
			set_target(target)

func set_target(target: Dome):
	target_position = target.global_position
	target_location = target
	movement_started.emit()

func set_highlight(is_enable: bool):
	$Sprite2D.material.set_shader_parameter("on", is_enable)
	if display_link:
		display_link.set_highlight(is_enable)
