extends "res://Itens/itens.gd"

export(float) var bateria_porcentagem


func _efeito() -> void:
	var lanterna = _jogador.get_node("Lanterna")
	lanterna.bateria += (lanterna.max_bateria / 100) * bateria_porcentagem
