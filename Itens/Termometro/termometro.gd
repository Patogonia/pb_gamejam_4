extends "res://Itens/itens.gd"

const TERMOMETRO_ALCANCE = preload("res://Itens/Termometro/TermometroAlcance.tscn")


func _efeito() -> void:
	var termometro_area = TERMOMETRO_ALCANCE.instance()
	_jogador.get_parent().add_child(termometro_area)
	termometro_area.position = _jogador.position
	termometro_area.connect("termometro_usado", _jogador, "_termometro")
