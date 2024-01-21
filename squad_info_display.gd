extends VBoxContainer

class_name SquadInfoDisplay

signal selected

var squad_link: Squad

func set_highlight(is_enable: bool):
	$TextureIcon.set_highlight(is_enable, is_enable)

func set_squad(squad: Squad):
	squad_link = squad
	squad.display_link = self
	match squad_link.squad_type:
		Globals.SquadType.SCIENTIST:
			set_text("Sci")
			set_tooltip("Scientists")
			set_icon("res://art/squad_sprites/GasMaskScientist_128.png")
		Globals.SquadType.PYRO:
			set_text("Pyr")
			set_tooltip("Pyros")
			set_icon("res://art/squad_sprites/GasmaskPyro_128.png")
		Globals.SquadType.BOTANIST:
			set_text("Bot")
			set_tooltip("Botanists")
			set_icon("res://art/squad_sprites/GasmaskBot_128.png")
		Globals.SquadType.ENGINEER:
			set_text("Eng")
			set_tooltip("Engineers")
			set_icon("res://art/squad_sprites/GasmaskSanitation_128.png")

func set_text(text: String):
	$Details/SquadAbbreviation.text = text
	
func set_tooltip(text: String):
	$TextureIcon.set_tooltip(text)

func set_icon(path: String):
	$TextureIcon.set_icon(path)
	
func set_action(action: Globals.ActionType):
	match action:
		Globals.ActionType.NONE:
			$Details/CurrentAction.texture = load("res://art/command_sprites/move_sprite_placeholder.png")
		Globals.ActionType.MOVE:
			$Details/CurrentAction.texture = load("res://art/command_sprites/move_sprite_placeholder.png")
		Globals.ActionType.SPECIAL:
			$Details/CurrentAction.texture = load("res://art/command_sprites/special_sprite_placeholder.png")
		Globals.ActionType.FIGHT:
			$Details/CurrentAction.texture = load("res://art/command_sprites/fight_sprite_placeholder.png")

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit(self)

func _on_texture_icon_gui_input(event):
	_on_gui_input(event)
