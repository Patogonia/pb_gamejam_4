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
	if Globais.hud.get_parent().level == 2:
		$HBoxContainer/Botao1.visible = false


func _ao_clicar_botao_1() -> void:
	if Globais.hud.get_parent().level == 1 and ganho:
		assert(get_tree().change_scene("res://Level2.tscn") == OK)
	else:
		assert(get_tree().reload_current_scene() == OK)


func _ao_clicar_menu_principal():
	# Mandar do menu principal
	assert(get_tree().change_scene("res://Menu/Menu.tscn") == OK)
