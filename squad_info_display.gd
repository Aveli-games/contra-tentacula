extends VBoxContainer

func set_text(text: String):
	$Details/SquadAbbreviation.text = text
	
func set_tooltip(text: String):
	$ClickableIcon.tooltip_text = text

func set_icon(icon_path: String):
	$ClickableIcon.icon = load(icon_path)
