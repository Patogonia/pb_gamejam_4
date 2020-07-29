extends "res://Itens/itens.gd"

export(String) var mensagem_ja_tomado
export(float) var multiplicador_de_velocidade
export(float) var buff_time


func _use(novo_jogador) -> void:
	# Checando se o player ja ta com um buff
	if novo_jogador.velocidade_maxima == novo_jogador.velocidade_maxima_original:
		._use(novo_jogador)
	else:
		novo_jogador.mostrar_mensagem(mensagem_ja_tomado)


func _efeito() -> void:
	# Aumenta a velocidade do player e ativa um timer q se conecta com o player
	_jogador.velocidade_maxima *= multiplicador_de_velocidade
	var timer = get_tree().create_timer(buff_time)
	timer.connect("timeout", _jogador, "_fim_buff_cafe")
