extends HBoxContainer

func set_text(text: String):
	$ResourceName.text = text

func set_amount(num: int):
	$ResourceAmount.text = str(num)
