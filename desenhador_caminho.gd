extends Node2D

export(float) var raio_circulo
export(Color) var cor_primeiro_pos
export(Color) var cor
export(Color) var cor_ultimo_pos


var caminho: PoolVector2Array setget _definir_caminho

func _ready() -> void:
	Globais.desenhador_caminho = self


func _definir_caminho(valor: PoolVector2Array) -> void:
	caminho = valor
	update()


func _draw() -> void:
	if caminho.size() > 0:
		for i in range(caminho.size()):
			var c: Color = cor
			if i == 0:
				c = cor_primeiro_pos
			elif i == caminho.size() - 1:
				c = cor_ultimo_pos
			
			draw_circle(caminho[i], raio_circulo, c)
