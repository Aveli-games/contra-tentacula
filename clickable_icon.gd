extends Control

func set_icon(path: String):
	$Button.icon = load(path)
	
func set_tooltip(text: String):
	$Button.tooltip_text = text
