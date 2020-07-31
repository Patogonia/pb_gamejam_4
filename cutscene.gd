extends Node

export(AudioStreamOGGVorbis) var musica 
export(int) var level
onready var tempo_inicial: int = OS.get_unix_time()

func _ready() -> void:
	Musica.stream = musica
	Musica.play()


func ganhar() -> void:
	var tempo_percorrido: int = OS.get_unix_time() - tempo_inicial
	_configurar_personagens()
	SalvarCarregar.salvar_pontuacao(name, tempo_percorrido)
	Globais.tela_ganhar_perder.exibir_ganhar(tempo_percorrido)


func perder() -> void:
	_configurar_personagens()
	var camera: Camera2D = Globais.jogador.get_node("Camera2D")
	$Tween.interpolate_property(camera, "global_position", camera.global_position, Globais.inimigo.global_position, 2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(1.5), "timeout")
	Globais.tela_ganhar_perder.exibir_perder()


func _configurar_personagens() -> void:
	Globais.jogador.ativo = false
	Globais.inimigo.ativo = false
	Globais.inimigo.definir_visivel(false)
