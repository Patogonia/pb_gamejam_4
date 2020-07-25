extends "res://Personagens/personagem.gd"

export(NodePath) var caminho_jogador
export(NodePath) var caminho_alvos_inimigo
export(float) var dist_min_fugir

var _jogador: KinematicBody2D
var _alvos_inimigo
var _alvo_pos: Vector2


func _ready() -> void:
	_jogador = get_node(caminho_jogador)
	_alvos_inimigo = get_node(caminho_alvos_inimigo)
	yield(get_tree(), "idle_frame")
	_atualizar_alvo()


func _process(_delta: float) -> void:
	if _jogador:
		var pos_j: Vector2 = _jogador.position
		var dist_i_j: float = position.distance_squared_to(pos_j)
		var dist_a_j: float = _alvo_pos.distance_squared_to(pos_j)
	
		if dist_i_j < dist_a_j and dist_i_j < pow(dist_min_fugir, 2):
			fugir_do_jogador()
		else:
			ir_ate_alvo()
	else:
		ir_ate_alvo()


func fugir_do_jogador() -> void:
	_direcao = -position.direction_to(_jogador.position)


func ir_ate_alvo() -> void:
	_direcao = position.direction_to(_alvo_pos)


func _atualizar_alvo() -> void:
	var novo_alvo: Node2D = _alvos_inimigo.pegar_alvo()
	if novo_alvo:
		_alvo_pos = novo_alvo.position
