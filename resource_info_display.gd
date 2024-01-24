extends HBoxContainer

@export var resource_type: Globals.ResourceType

func _ready():
	Globals.resource_updated.connect(_on_resource_updated)
	if find_child("ProgressBar"):
		$ProgressBar.max_value = Globals.RESEARCH_WIN_THRESHOLD

func set_text(text: String):
	$ResourceName.text = text

func set_amount(num: int):
	$ResourceAmount.text = str(num)

func _on_resource_updated(type: Globals.ResourceType):
	if resource_type && resource_type == type:
		$ResourceAmount.text = str(floor(Globals.resources[type]))
		if resource_type == Globals.ResourceType.RESEARCH:
			$ProgressBar.value = Globals.resources[resource_type]
