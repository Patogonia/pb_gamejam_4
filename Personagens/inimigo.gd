extends "res://Personagens/personagem.gd"


export(NodePath) var caminho_jogador
export(NodePath) var caminho_alvos_inimigo
export(NodePath) var caminho_mapa_pathfinding
export(NodePath) var caminho_desenhador_caminho
export(bool) var visualizar_caminho
export(float) var dist_min_fugir

onready var alvos_inimigo = get_node(caminho_alvos_inimigo)
onready var mapa_pathfinding = get_node(caminho_mapa_pathfinding)
onready var jogador: KinematicBody2D = get_node(caminho_jogador)
onready var _desenhador_caminho = get_node(caminho_desenhador_caminho)
onready var _maquina_de_estados = $MaquinaDeEstados
onready var _detector_jogador: RayCast2D = $DetectorJogador
onready var _tempo_stun: Timer = $TempoStun

var caminho_a_percorrer: PoolVector2Array
var _stunado: bool = false
var _indice_pos_caminho: int = 0
var _posicoes_desenhadas: Array = []


func _process(delta: float) -> void:
	_maquina_de_estados.executar(delta)
	
	if jogador:
		_detector_jogador.cast_to = position.direction_to(jogador.position) * dist_min_fugir


func distancia_jogador_ao_quadrado() -> float:
	return position.distance_squared_to(jogador.position)


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
	caminho_a_percorrer = mapa_pathfinding.pegar_caminho_coords_mundo(position, alvo)
	
	if visualizar_caminho:
		_desenhar_caminho()


func resetar_caminho() -> void:
	caminho_a_percorrer = []
	_indice_pos_caminho = 0


func _desenhar_caminho() -> void:
	if visualizar_caminho:
		_desenhador_caminho.caminho = caminho_a_percorrer


func _processar_movimento(delta: float) -> void:
	if not _stunado:
		._processar_movimento(delta)


func stunar(tempo: float) -> void:
	_tempo_stun.start(tempo)
	_stunado = true


func destunar() -> void:
	_stunado = false
