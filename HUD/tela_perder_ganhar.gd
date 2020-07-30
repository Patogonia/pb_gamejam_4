extends Control

var ganho: bool

func exibir_perder() -> void:
	ganho = false
	$AnimationPlayer.play("Perder")


func exibir_ganhar() -> void:
	ganho = true
	$AnimationPlayer.play("Ganhar")


func _ao_clicar_botao_1() -> void:
	if ganho:
		pass # Mandar para proximo nivel
	else:
		get_tree().reload_current_scene()


func _ao_clicar_menu_principal():
	# Mandar do menu principal
	get_tree().change_scene("res://Menu/Menu.tscn")
