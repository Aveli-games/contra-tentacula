extends VBoxContainer

func set_text(text: String):
	$Details/SquadAbbreviation.text = text
	
func set_tooltip(text: String):
	$ClickableIcon/Button.tooltip_text = text

func set_icon(path: String):
	$ClickableIcon.set_icon(path)
