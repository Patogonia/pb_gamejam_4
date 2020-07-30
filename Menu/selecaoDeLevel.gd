extends Control

func _process(_delta: float):
	var new_scale = Vector2(1, 1)
	new_scale.x = (OS.get_window_size().x / (1024 / 100)) / 70
	new_scale.y = (OS.get_window_size().y / (600 / 100)) / 70
	$Level1/Control/Sprite.scale = new_scale
	$Level2/Control/Sprite.scale = new_scale


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
