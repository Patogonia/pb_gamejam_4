extends "res://Personagens/MaquinaDeEstados/Estado.gd"

export(bool) var testar_caminho
export(float) var tempo_atualizar_alvo
export(float) var distancia_max

var _alvo_atual: Node2D
var _cronometro_atualizar_alvo: Timer


func iniciar(maquina_de_estado) -> void:
	.iniciar(maquina_de_estado)
	_cronometro_atualizar_alvo = Timer.new()
	_cronometro_atualizar_alvo.wait_time = tempo_atualizar_alvo
	_cronometro_atualizar_alvo.connect("timeout", self, "_atualizar_alvo")
	call_deferred("add_child", _cronometro_atualizar_alvo)


func entrar() -> void:
	if not _alvo_atual:
		_atualizar_alvo()
	
	_cronometro_atualizar_alvo.start()


func executar(_delta: float) -> String:
	# Fugir do jogador quando ele estiver visivel
	# Talvez seria melhor se ele estivesse proximo
	if _personagem.jogador_esta_visivel():
		return "FugirJogador"
	
	# Nao possui mais alvos. Fique parado
	if Globais.alvos.get_child_count() == 0:
		_personagem._direcao = Vector2.ZERO
		return ""
	
	# Alvo e nulo, pegue outro alvo
	if not is_instance_valid(_alvo_atual) or not _alvo_atual:
		_atualizar_alvo()
	
	# Gerar outro caminho se o caminho retornado e vazio ou ja foi percorrido todo o caminho
	var tam_caminho: int = _personagem.caminho_a_percorrer.size()
	if tam_caminho == 0 or _personagem._indice_pos_caminho >= tam_caminho:
		_atualizar_caminho()
	
	# Percorrer o caminho
	_personagem.percorrer_caminho()
	
	return ""


func sair() -> void:
	_alvo_atual = null
	_personagem.resetar_caminho()
	_cronometro_atualizar_alvo.stop()


func _atualizar_caminho() -> void:
	if _alvo_atual:
		var pos_alvo: Vector2 = _alvo_atual.position
	#	var pos_personagem: Vector2 = _personagem.position
	#	if pos_alvo.distance_squared_to(_personagem.position) < pow(distancia_max, 2):
		_personagem.atualizar_caminho(pos_alvo)
	#	else:
	#		_personagem.atualizar_caminho(pos_personagem.direction_to(pos_alvo) * distancia_max * .75)


func _atualizar_alvo() -> void:
	if Globais.alvos.get_child_count() > 0:
		var novo_alvo: Node2D = Globais.alvos.pegar_alvo() 
		if novo_alvo == _alvo_atual:
			# Talvez dar uma olhada se o caminho ainda ta ok ?
			pass
		else:
			_alvo_atual = novo_alvo
			_atualizar_caminho()
	else:
		_alvo_atual = null
