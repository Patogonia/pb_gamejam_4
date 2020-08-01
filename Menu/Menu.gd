extends Control

export(AudioStreamOGGVorbis) var musica


func _ready():
	Input.set_custom_mouse_cursor(load("res://cursor_menu.png"))
	if Musica.stream == musica:
		return
	Musica.stream = musica
	Musica.play()


func _process(_delta: float):
	$Background.scale.x = (OS.get_window_size().x / (1024 / 100)) / 100
	$Background.scale.y = (OS.get_window_size().y / (600 / 100)) / 100


func _on_PlayButton_pressed():
	assert(get_tree().change_scene("res://Menu/Instrucoes.tscn") == OK)


func _on_CreditsButton_pressed():
	assert(get_tree().change_scene("res://Menu/Creditos.tscn") == OK)


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_TrovaoTimer_timeout():
	var strenght = rand_range(1, 4)
	$Background/Trovao/Tween.interpolate_property($Background/Trovao, "energy", strenght, 0, 0.5, Tween.TRANS_LINEAR)
	$Background/Trovao/Tween.start()
	$Background/Trovao/TrovaoSom.play(clamp(strenght / 2, 0, 1.25))
	$Background/Trovao/TrovaoSom.volume_db = ((strenght - 1) * 2) - 7
	randomize()
	$Background/Trovao/Timer.start(rand_range(5, 10))
