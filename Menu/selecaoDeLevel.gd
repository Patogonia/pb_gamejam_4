extends Control

func _ready() -> void:
	for mapa in SalvarCarregar.save_carregado.keys():
		get_node(mapa+"/BestTimeLabel").text = "Best Time: " + Globais.formatar_tempo(SalvarCarregar.save_carregado[mapa])


func _process(_delta: float):
	var new_scale = Vector2(1, 1)
	new_scale.x = (OS.get_window_size().x / (1024 / 100)) / 70
	new_scale.y = (OS.get_window_size().y / (600 / 100)) / 70
	$Outside/Control/Sprite.scale = new_scale
	$TheBuilding/Control/Sprite.scale = new_scale / 2.4


func _on_MenuButton_pressed():
	assert(get_tree().change_scene("res://Menu/Menu.tscn") == OK)


func _on_Button_Level1_pressed():
	fade()
	yield(get_tree().create_timer(1.5), "timeout")
	assert(get_tree().change_scene("res://CenaTeste.tscn") == OK)

func _on_Button_Level2_pressed():
	if SalvarCarregar.save_carregado.Outside != 0:
		fade()
		yield(get_tree().create_timer(1.5), "timeout")
		assert(get_tree().change_scene("res://Level2.tscn") == OK)


func fade() -> void:
	$Trasition.visible = true
	$Trasition/Tween.interpolate_property($Trasition, "color", Color("#00000000"), Color("#000000"), 1, Tween.TRANS_LINEAR)
	$Trasition/Tween.start()
