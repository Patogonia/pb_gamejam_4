extends Node

# Personagens
var jogador
var inimigo

# Interface
var hud
var inventario
var tela_ganhar_perder

# Outros
var alvos
var mapa_pathfinding
var desenhador_caminho
var armazem_armadilhas


func formatar_tempo(t: int) -> String:
	return "{m}:{s}".format({
		"m": "%02d" % (t / 60),
		"s": "%02d" % (t % 60)
	})
	
