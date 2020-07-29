extends "res://Itens/itens.gd"

const TERMOMETRO_ALCANCE = preload("res://Itens/Termometro/TermometroAlcance.tscn")


func _efeito() -> void:
	var termometro_area = TERMOMETRO_ALCANCE.instance()
	termometro_area.jogador = _jogador
	_jogador.get_parent().call_deferred("add_child", termometro_area)
	termometro_area.position = _jogador.position
