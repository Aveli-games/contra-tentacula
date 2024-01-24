extends Control

class_name TextureIcon

signal selected

const HIGHLIGHT_COLOR = Color.YELLOW
const MOUSEOVER_COLOR = Color.CYAN
const BACKGROUND_COLOR = Color.DARK_CYAN

var is_selected: bool = false
var mouseover: bool = true

func _ready():
	set_highlight(false, is_selected)

func set_highlight(is_enable: bool, icon_selected: bool):
	is_selected = icon_selected
	if is_enable:
		if mouseover && not is_selected:
			$Background.material.set_shader_parameter("line_color", MOUSEOVER_COLOR)
		else:
			$Background.material.set_shader_parameter("line_color", HIGHLIGHT_COLOR)
	$Background.material.set_shader_parameter("on", is_enable)

func set_icon(path: String):
	$IconTexture.texture = load(path)

func get_icon():
	return $IconTexture.texture
	
func set_tooltip(text: String):
	$IconTexture.tooltip_text = text

func set_hotkey(text: String):
	$Hotkey/Label.text = text

func _on_mouse_entered():
	mouseover = true
	set_highlight(true, is_selected)

func _on_mouse_exited():
	mouseover = false
	if not is_selected:
		set_highlight(false, is_selected)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit(self)
