extends Control



func _on_NextButton_pressed():
	assert(get_tree().change_scene("res://Menu/SelecaoDeLevel.tscn") == OK)


func _on_MenuButton_pressed():
	assert(get_tree().change_scene("res://Menu/Menu.tscn") == OK)
