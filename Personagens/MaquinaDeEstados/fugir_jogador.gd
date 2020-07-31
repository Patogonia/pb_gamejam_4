extends "res://Personagens/MaquinaDeEstados/Estado.gd"

enum MetodoPegarPosFuga {
	DirecaoOpostoAoJogador,
	MelhorPontoEmCircunferencia,
	Raycasting
}

const _DIRECOES_METODO_RAYCAST: int = 16
const _DIST_MAX_RAYCAST: float = 1000.0

export(float) var tempo_atualizar_direcao
export(float) var distancia_fugir
export(MetodoPegarPosFuga) var metodo_fuga

var _cronometro_atualizar_direcao: Timer
var _pos_alvo: Vector2

func iniciar(maquina_de_estados) -> void:
	.iniciar(maquina_de_estados)
	
	_cronometro_atualizar_direcao = Timer.new()
	_cronometro_atualizar_direcao.wait_time = tempo_atualizar_direcao
	_cronometro_atualizar_direcao.connect("timeout", self, "_atualizar_pos_alvo")
	call_deferred("add_child", _cronometro_atualizar_direcao)


func entrar() -> void:
	_atualizar_pos_alvo()
	_cronometro_atualizar_direcao.start()


func executar(_delta: float) -> String:
	if _personagem.distancia_jogador_ao_quadrado() > pow(_personagem.dist_min_fugir * 1.5, 2):
		return "PegarAlvo"
	
	if metodo_fuga == MetodoPegarPosFuga.Raycasting:
		_personagem.andar_em_direcao_a_pos(_pos_alvo)
	else:
		_personagem.percorrer_caminho()
	
	return ""


func sair() -> void:
	_personagem.resetar_caminho()
	_cronometro_atualizar_direcao.stop()


func _atualizar_pos_alvo() -> void:
	match metodo_fuga:
		MetodoPegarPosFuga.MelhorPontoEmCircunferencia:
			var pontos_fuga: PoolVector2Array = Globais.mapa_pathfinding.pegar_pontos_em_circunferencia_mundo(_personagem.position, distancia_fugir)
		
			if pontos_fuga.size() > 0:
				var melhor_ponto_escalar: int = 1
				var pos_pers: Vector2 = _personagem.position
				var dir_pers_jog: Vector2 = _personagem.position.direction_to(Globais.jogador.position)
		
				for ponto in pontos_fuga:
					var dir_pers_ponto: Vector2 = pos_pers.direction_to(ponto)
					var escalar_dirs: float = dir_pers_ponto.dot(dir_pers_jog)
					if escalar_dirs < melhor_ponto_escalar:
						melhor_ponto_escalar = escalar_dirs
						_pos_alvo = ponto
				
				_personagem.atualizar_caminho(_pos_alvo, true)
			else:
				continue # Executar abaixo
		MetodoPegarPosFuga.DirecaoOpostoAoJogador:
			var dir_fugir: Vector2 = -_personagem.position.direction_to(Globais.jogador.position)
			_pos_alvo = _personagem.position + dir_fugir * distancia_fugir
			_personagem.atualizar_caminho(_pos_alvo, true)
		MetodoPegarPosFuga.Raycasting:
			var incremento = 2 * PI / _DIRECOES_METODO_RAYCAST
			var pos_pers: Vector2 = _personagem.position
			var dir_pers_jogador: Vector2 = pos_pers.direction_to(Globais.jogador.position)
			var melhor_pont: float = 0
			var estado_espaco = _personagem.get_world_2d().direct_space_state
			
			for i in range(_DIRECOES_METODO_RAYCAST):
				var resultado: Dictionary = estado_espaco.intersect_ray(pos_pers, pos_pers + Vector2.RIGHT.rotated(i * incremento) * _DIST_MAX_RAYCAST, [_personagem], 4)
				if not resultado.empty():
					var pos: Vector2 = resultado.position
					var dir_pers_p: Vector2 = pos_pers.direction_to(pos)
					var pontuacao = pos_pers.distance_squared_to(pos) * (-dir_pers_jogador.dot(dir_pers_p) * .5 + .5)
					if pontuacao > melhor_pont:
						_pos_alvo = pos
						melhor_pont = pontuacao
