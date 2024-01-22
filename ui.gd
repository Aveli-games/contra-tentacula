extends CanvasLayer

signal action_selected

# Setting up the UI is a bit static at this point. I think UI work is where I could
#    use the most improvement, but will leave polish on it for if we have time

# TODO: Dynamically populate icons, primarily squad commands, based on available
#    squad properties

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up resource display
	$RightSidebar/ResourceDisplay/FoodInfo.set_text("Food")
	$RightSidebar/ResourceDisplay/FoodInfo.set_amount(Globals.resources[Globals.ResourceType.FOOD])
	$RightSidebar/ResourceDisplay/ResearchInfo.set_text("Research")
	$RightSidebar/ResourceDisplay/ResearchInfo.set_amount(Globals.resources[Globals.ResourceType.RESEARCH])
	$RightSidebar/ResourceDisplay/FuelInfo.set_text("Fuel")
	$RightSidebar/ResourceDisplay/FuelInfo.set_amount(Globals.resources[Globals.ResourceType.FUEL])
	$RightSidebar/ResourceDisplay/PartsInfo.set_text("Parts")
	$RightSidebar/ResourceDisplay/PartsInfo.set_amount(Globals.resources[Globals.ResourceType.PARTS])

func _on_move_button_selected(button: TextureIcon):
	Input.set_custom_mouse_cursor(button.get_icon())
	action_selected.emit(Globals.ActionType.MOVE)

func _on_special_button_selected(button: TextureIcon):
	Input.set_custom_mouse_cursor(button.get_icon())
	action_selected.emit(Globals.ActionType.SPECIAL)

func _on_fight_button_selected(button: TextureIcon):
	Input.set_custom_mouse_cursor(button.get_icon())
	action_selected.emit(Globals.ActionType.FIGHT)
