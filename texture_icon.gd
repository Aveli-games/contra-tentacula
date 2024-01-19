extends Control

const HIGHLIGHT_COLOR = Color.YELLOW
const BACKGROUND_COLOR = Color.DARK_CYAN

func _ready():
	set_highlight(false)

func set_highlight(is_enable: bool):
	if is_enable:
		$Background.color = HIGHLIGHT_COLOR
	else:
		$Background.color = BACKGROUND_COLOR

func set_icon(path: String):
	$IconTexture.texture = load(path)
	
func set_tooltip(text: String):
	$IconTexture.tooltip_text = text
