extends "res://Itens/itens.gd"

const RAIO = preload("res://Itens/Taser/RaioTaser.tscn")

export(float) var range_de_efeito
export(float) var velocidade
export(float) var tempo_de_stun


func _efeito() -> void:
	var raio_instance = RAIO.instance()
	_jogador.get_parent().add_child(raio_instance)
	raio_instance.position = _jogador.position
	raio_instance.rotation_degrees = _jogador.get_node("Lanterna").rotation_degrees
	raio_instance.max_iteracoes = range_de_efeito
	raio_instance.tempo_de_stun = self.tempo_de_stun
	raio_instance.get_node("Timer").wait_time = velocidade
	raio_instance.get_node("Timer").start(velocidade)
