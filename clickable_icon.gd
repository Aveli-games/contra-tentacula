extends Control

const HIGHLIGHT_COLOR = Color.YELLOW
const BACKGROUND_COLOR = Color.DARK_CYAN

func _ready():
	set_highlight(false)

func set_highlight(is_enable: bool):
	if is_enable:
		$ColorRect.color = HIGHLIGHT_COLOR
	else:
		$ColorRect.color = BACKGROUND_COLOR

func set_icon(path: String):
	$Button.icon = load(path)
	
func set_tooltip(text: String):
	$Button.tooltip_text = text
