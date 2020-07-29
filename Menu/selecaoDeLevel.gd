extends Control


func _on_MenuButton_pressed():
	assert(get_tree().change_scene("res://Menu/Menu.tscn") == OK)


func _on_Button_Level1_pressed():
	$Trasition.visible = true
	$Trasition/Tween.interpolate_property($Trasition, "color", Color("#00000000"), Color("#000000"), 1, Tween.TRANS_LINEAR)
	$Trasition/Tween.start()
	yield(get_tree().create_timer(1.5), "timeout")
	assert(get_tree().change_scene("res://CenaTeste.tscn") == OK)

func _on_Button_Level2_pressed():
	pass # Replace with function body.
