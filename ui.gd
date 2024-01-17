extends CanvasLayer

# Setting up the UI is a bit static at this point. I think UI work is where I could
#    use the most improvement, but will leave polish on it for if we have time

# TODO: Dynamically populate icons, primarily squad commands, based on available
#    squad properties

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up resource display
	$RightSidebar/ResourceDisplay/FoodInfo.set_text("Food")
	$RightSidebar/ResourceDisplay/FoodInfo.set_amount(Globals.resources["food"])
	$RightSidebar/ResourceDisplay/ResearchInfo.set_text("Research")
	$RightSidebar/ResourceDisplay/ResearchInfo.set_amount(Globals.resources["research"])
	$RightSidebar/ResourceDisplay/FuelInfo.set_text("Fuel")
	$RightSidebar/ResourceDisplay/FuelInfo.set_amount(Globals.resources["fuel"])
	$RightSidebar/ResourceDisplay/PartsInfo.set_text("Parts")
	$RightSidebar/ResourceDisplay/PartsInfo.set_amount(Globals.resources["parts"])
	
	# Set up squad display
	$RightSidebar/SquadDisplay/Scientists.set_text("Sci")
	$RightSidebar/SquadDisplay/Scientists.set_tooltip("Scientists")
	$RightSidebar/SquadDisplay/Scientists.set_icon("res://art/squad_sprites/GasMaskScientist_128.png")
	$RightSidebar/SquadDisplay/Pyros.set_text("Pyr")
	$RightSidebar/SquadDisplay/Pyros.set_tooltip("Pyros")
	$RightSidebar/SquadDisplay/Pyros.set_icon("res://art/squad_sprites/GasmaskPyro_128.png")
	$RightSidebar/SquadDisplay/Botanists.set_text("Bot")
	$RightSidebar/SquadDisplay/Botanists.set_tooltip("Botanists")
	$RightSidebar/SquadDisplay/Botanists.set_icon("res://art/squad_sprites/GasmaskBot_128.png")
	$RightSidebar/SquadDisplay/Engineers.set_text("Eng")
	$RightSidebar/SquadDisplay/Engineers.set_tooltip("Engineers")
	$RightSidebar/SquadDisplay/Engineers.set_icon("res://art/squad_sprites/GasmaskSanitation_128.png")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
