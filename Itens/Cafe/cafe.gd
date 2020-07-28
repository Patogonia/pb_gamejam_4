extends "res://Itens/itens.gd"

export(float) var multiplicador_de_velocidade
export(float) var buff_time


func _use(novo_jogador) -> void:
	_jogador = novo_jogador
	# Checando se o player ja ta com um buff
	if _jogador.velocidade_maxima == _jogador.velocidade_maxima_original:
		_efeito()
		usos -= 1
		if usos <= 0:
			inventario._matar_item(self)


func _efeito() -> void:
	# Aumenta a velocidade do player e ativa um timer q se conecta com o player
	_jogador.velocidade_maxima *= multiplicador_de_velocidade
	var timer = get_tree().create_timer(buff_time)
	timer.connect("timeout", _jogador, "_fim_buff_cafe")
