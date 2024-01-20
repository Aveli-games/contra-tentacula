extends Control

class_name TextureIcon

const HIGHLIGHT_COLOR = Color.YELLOW
const MOUSEOVER_COLOR = Color.CYAN
const BACKGROUND_COLOR = Color.DARK_CYAN

var selected: bool = false
var mouseover: bool = true

func _ready():
	set_highlight(false, selected)

func set_highlight(is_enable: bool, is_selected: bool):
	selected = is_selected
	if is_enable:
		if mouseover && not selected:
			$Background.color = MOUSEOVER_COLOR
		else:
			$Background.color = HIGHLIGHT_COLOR
	else:
		$Background.color = BACKGROUND_COLOR

func set_icon(path: String):
	$IconTexture.texture = load(path)
	
func set_tooltip(text: String):
	$IconTexture.tooltip_text = text

func _on_mouse_entered():
	mouseover = true
	set_highlight(true, selected)

func _on_mouse_exited():
	mouseover = false
	if not selected:
		set_highlight(false, selected)
