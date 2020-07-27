extends "res://Personagens/MaquinaDeEstados/Estado.gd"


export(float) var tempo_atualizar_direcao
export(float) var distancia_fugir

var _cronometro_atualizar_direcao: Timer

func iniciar(maquina_de_estados) -> void:
	.iniciar(maquina_de_estados)
	
	_cronometro_atualizar_direcao = Timer.new()
	_cronometro_atualizar_direcao.wait_time = tempo_atualizar_direcao
	_cronometro_atualizar_direcao.connect("timeout", self, "_atualizar_direcao")
	call_deferred("add_child", _cronometro_atualizar_direcao)


func entrar() -> void:
	_atualizar_direcao()
	_cronometro_atualizar_direcao.start()


func executar(_delta: float) -> String:
	if _personagem.distancia_jogador_ao_quadrado() > pow(_personagem.dist_min_fugir * 1.5, 2):
		return "PegarAlvo"
	
	_personagem.percorrer_caminho()
	
	return ""


func sair() -> void:
	_personagem.resetar_caminho()
	_cronometro_atualizar_direcao.stop()


func _atualizar_direcao() -> void:
	var dir_fugir = -_personagem.position.direction_to(_personagem.jogador.position)
	var vetor_fugir = dir_fugir * distancia_fugir
	
	_personagem.atualizar_caminho(vetor_fugir)
