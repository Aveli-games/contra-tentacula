extends VBoxContainer

class_name SquadInfoDisplay

var squad_link: Squad

func set_highlight(is_enable: bool):
	$ClickableIcon.set_highlight(is_enable)

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
	$ClickableIcon.set_tooltip(text)

func set_icon(path: String):
	$ClickableIcon.set_icon(path)
