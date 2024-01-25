extends TextureProgressBar

var animate_off = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animate_off && value > 0:
		value -= 1

func _on_button_pressed():
	$Button.hide()
	animate_off = true
