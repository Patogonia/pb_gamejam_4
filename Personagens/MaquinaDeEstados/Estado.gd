extends Node

var _maquina_de_estado
var _personagem: KinematicBody2D

func iniciar(maquina_de_estado) -> void:
	_maquina_de_estado = maquina_de_estado
	_personagem = _maquina_de_estado.personagem


func entrar() -> void:
	pass


func executar(_delta: float) -> String:
	return ""


func sair() -> void:
	pass
