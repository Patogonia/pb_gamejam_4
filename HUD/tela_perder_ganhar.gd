extends Control

const _TEMPLATE_TEXTO_TEMPO: String = "Elapsed time: {t}"

var ganho: bool

func exibir_perder() -> void:
	ganho = false
	self.visible = true
	$AnimationPlayer.play("Perder")


func exibir_ganhar(tempo: int) -> void:
	ganho = true
	self.visible = true
	$Tempo.text = _TEMPLATE_TEXTO_TEMPO.format({"t": Globais.formatar_tempo(tempo)})
	$AnimationPlayer.play("Ganhar")



func _ao_clicar_botao_1() -> void:
	if ganho:
		pass # Mandar para proximo nivel
	else:
		get_tree().reload_current_scene()


func _ao_clicar_menu_principal():
	# Mandar do menu principal
	get_tree().change_scene("res://Menu/Menu.tscn")
