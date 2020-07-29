extends "res://Personagens/personagem.gd"


export(bool) var visualizar_caminho
export(float) var dist_min_fugir

onready var _maquina_de_estados = $MaquinaDeEstados
onready var _detector_jogador: RayCast2D = $DetectorJogador
onready var _tempo_stun: Timer = $TempoStun

var caminho_a_percorrer: PoolVector2Array
var _stunado: bool = false
var _indice_pos_caminho: int = 0
var _posicoes_desenhadas: Array = []


func _ready() -> void:
	Globais.inimigo = self


func _process(delta: float) -> void:
	_maquina_de_estados.executar(delta)
	
	if Globais.jogador:
		_detector_jogador.cast_to = position.direction_to(Globais.jogador.position) * dist_min_fugir


func distancia_jogador_ao_quadrado() -> float:
	return position.distance_squared_to(Globais.jogador.position)


func percorrer_caminho() -> void:
	if caminho_a_percorrer.size() == 0:
		_direcao = Vector2.ZERO
		return
	
	if position.distance_squared_to(caminho_a_percorrer[_indice_pos_caminho]) < 5*5:
		if _indice_pos_caminho + 1 < caminho_a_percorrer.size():
			_indice_pos_caminho += 1
		else:
			_direcao = Vector2.ZERO
			return
	
	_direcao = position.direction_to(caminho_a_percorrer[_indice_pos_caminho])


func jogador_esta_visivel() -> bool:
	if not _detector_jogador.is_colliding():
		return false
	
	return _detector_jogador.get_collider().name == "Jogador"


func atualizar_caminho(alvo: Vector2) -> void:
	resetar_caminho()
	caminho_a_percorrer = Globais.mapa_pathfinding.pegar_caminho_coords_mundo(position, alvo)
	
	if visualizar_caminho:
		_desenhar_caminho()


func resetar_caminho() -> void:
	caminho_a_percorrer = []
	_indice_pos_caminho = 0


func _desenhar_caminho() -> void:
	if visualizar_caminho:
		Globais.desenhador_caminho.caminho = caminho_a_percorrer


func _processar_movimento(delta: float) -> void:
	if not _stunado:
		._processar_movimento(delta)


func stunar(tempo: float) -> void:
	_tempo_stun.start(tempo)
	_stunado = true


func destunar() -> void:
	_stunado = false
