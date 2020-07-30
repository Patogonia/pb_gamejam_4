extends "res://Personagens/personagem.gd"


export(bool) var visualizar_caminho
export(float) var dist_min_fugir
export(int) var qnt_alvos

onready var _maquina_de_estados = $MaquinaDeEstados
onready var _detector_jogador: RayCast2D = $DetectorJogador
onready var _tempo_stun: Timer = $TempoStun

var caminho_a_percorrer: PoolVector2Array
var _stunado: bool = false
var _indice_pos_caminho: int = 0
var _posicoes_desenhadas: Array = []
var alvos_pego: int = 0 setget _definir_alvos_pego


func _ready() -> void:
	Globais.inimigo = self


func _process(delta: float) -> void:
	_maquina_de_estados.executar(delta)
	
	if Globais.jogador:
		_detector_jogador.cast_to = position.direction_to(Globais.jogador.position) * dist_min_fugir


func distancia_jogador_ao_quadrado() -> float:
	return position.distance_squared_to(Globais.jogador.position)


func definir_visivel(v: bool):
	$Sprite.material.light_mode = CanvasItemMaterial.LIGHT_MODE_LIGHT_ONLY if v else CanvasItemMaterial.LIGHT_MODE_NORMAL 


func andar_em_direcao_a_pos(pos: Vector2) -> void:
	_direcao = position.direction_to(pos)


func percorrer_caminho() -> void:
	if caminho_a_percorrer.size() == 0:
		_direcao = Vector2.ZERO
		return
	
#	var pos_atual: Vector2 = caminho_a_percorrer[_indice_pos_caminho]
#	var prox_pos: Vector2 = Vector2.ZERO if _indice_pos_caminho + 1 >= caminho_a_percorrer.size() else caminho_a_percorrer[_indice_pos_caminho + 1]
#	var dir_pers_pos_cam: Vector2 = pos_atual.direction_to(position)
#	var dir_posatual_proxpos: Vector2 = pos_atual.direction_to(prox_pos)
	
	# Passar pro proximo ponto se ele estiver perto deste ponto e estiver relativamente entre este e o proximo ponto
	if position.distance_squared_to(caminho_a_percorrer[_indice_pos_caminho]) < 10*10:
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


func atualizar_caminho(alvo: Vector2, fugindo: bool = false) -> void:
	resetar_caminho()
	caminho_a_percorrer = Globais.mapa_pathfinding.pegar_caminho_coords_mundo(position, alvo, fugindo)
	
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
	# Talvez algo externo queira destunar, dai nesse caso, pare o cronometro
	_tempo_stun.stop()
	
	_stunado = false


func _definir_ativo(v: bool) -> void:
	._definir_ativo(v)
	set_process(v)
	_detector_jogador.enabled = v
	
	if not v:
		destunar()
		resetar_caminho()

func _definir_alvos_pego(v: int) -> void:
	if ativo:
		alvos_pego = v
		
		if alvos_pego >= qnt_alvos:
			get_tree().current_scene.perder()
