extends Node

onready var personagem: KinematicBody2D = get_parent()

var _estado_atual


func iniciar() -> void:
	for estado in get_children():
		estado.iniciar(self)


func executar(delta: float) -> void:
	if _estado_atual:
		var novo_estado: String = _estado_atual.executar(delta)
		if novo_estado != "":
			mudar_de_estado(novo_estado)
	else:
		mudar_de_estado(get_child(0).name)


func mudar_de_estado(nome_estado: String) -> void:
	if _estado_atual:
		_estado_atual.sair()
	
	_estado_atual = get_node(nome_estado)
	_estado_atual.entrar()
	print("Entrado estado ", nome_estado)
