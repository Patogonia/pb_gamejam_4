extends "res://Itens/itens.gd"

const ARMADILHA_ATIVA = preload("res://Itens/Armadilha/ArmadilhaAtiva.tscn")

var mesa


func _efeito() -> void:
	# Cria a armadilha onde o player ta e conecta o sinal com o player e a mesa
	var armadilha_instance = ARMADILHA_ATIVA.instance()
	_jogador.get_parent().get_node("Armadilhas").add_child(armadilha_instance)
	armadilha_instance.position = _jogador.position
	armadilha_instance.connect("inimigo_detectado", _jogador, "_armadilha_ativada")
	armadilha_instance.connect("inimigo_detectado", mesa, "_mesa_desativada")
