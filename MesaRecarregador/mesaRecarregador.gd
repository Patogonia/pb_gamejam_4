extends StaticBody2D

const MENSAGEM: String = "Recharged Bateries!"

var jogador
var jogador_na_area: bool = false


func _process(_delta: float) -> void:
	# Se o jogador clicar o botao de interagir e estiver na area da mesa ele recarrega a bateria
	if Input.is_action_just_pressed("interagir") and jogador_na_area:
		jogador.get_node("Lanterna")._recarregar()
		jogador.mostrar_mensagem(MENSAGEM)
		$BotaoSprite.frame = 0
		$BotaoSprite.play("default")


# Quando o jogador entra na area da mesa a variavel fica true pra ele poder interagir
func _on_Area2D_body_entered(body) -> void:
	jogador = body
	jogador_na_area = true
	$BotaoSprite.visible = true


# Quando o jogador sai da area da mesa a variavel fica false pra ele n poder interagir
func _on_Area2D_body_exited(_body) -> void:
	jogador_na_area = false
	$BotaoSprite.visible = false


# Mudar a posição do label pra ele seguir a animação do botao
func _on_BotaoSprite_frame_changed():
	if $BotaoSprite.frame == 0:
		$BotaoSprite/Label.valign = VALIGN_CENTER
	elif $BotaoSprite.frame == 4:
		$BotaoSprite/Label.valign = VALIGN_CENTER
		$BotaoSprite.stop()
	else:
		$BotaoSprite/Label.valign = VALIGN_BOTTOM
