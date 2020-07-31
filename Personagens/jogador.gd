extends "res://Personagens/personagem.gd"

onready var raycast_inimigo: RayCast2D = $RaycastInimigo
onready var _mensagem: Node2D = $Mensagem
onready var _texto: Label = $Mensagem/Texto
onready var _mensagem_tween: Tween = $Mensagem/Texto/Tween
onready var _timer_esconder_mens: Timer = $Mensagem/Texto/TimerEsconder

export(float) var zoom_camera = .25

var velocidade_maxima_original
var posicao_armadilha = Vector2(0, 0)


func _ready() -> void:
	Globais.jogador = self
	velocidade_maxima_original = velocidade_maxima
	$Camera2D.zoom = Vector2(zoom_camera, zoom_camera)
	Input.set_custom_mouse_cursor(load("res://cursor_ingame.png"))
	yield(get_tree(), "idle_frame")
	mostrar_mensagem("Sneaky Boy will arrive in %d seconds!" % get_tree().current_scene.get_node("SpawnAleatorioInimigo").tempo_spawnar)


func _physics_process(_d: float) -> void:
	# Pegar direcao
	_direcao.x = int(Input.is_action_pressed("andar_pra_direita")) - int(Input.is_action_pressed("andar_pra_esquerda"))
	_direcao.y = int(Input.is_action_pressed("andar_pra_baixo")) - int(Input.is_action_pressed("andar_pra_cima"))
	_direcao = _direcao.normalized()
	
	var inimigo = Globais.inimigo
	if is_instance_valid(Globais.inimigo):
		raycast_inimigo.cast_to = position.direction_to(inimigo.position) * 8
		var colisor = raycast_inimigo.get_collider()
		if colisor and $Lanterna.ligada:
			get_tree().current_scene.ganhar()
			return
	
	$SetaArmadilha.look_at(posicao_armadilha)


func _fim_buff_cafe():
	self.velocidade_maxima = velocidade_maxima_original


func _armadilha_ativada(nova_posicao_armadilha):
	posicao_armadilha = nova_posicao_armadilha
	$SetaArmadilha.visible = true
	get_tree().create_timer(7).connect("timeout", self, "_desativar_termometro_seta", ["seta"])


func _desativar_termometro_seta(qual: String):
	if qual == "seta":
		$SetaArmadilha.visible = false


func mostrar_mensagem(mensagem: String) -> void:
	_texto.text = mensagem
	_mensagem_tween.interpolate_property(_mensagem, "modulate", Color.transparent, Color.white, .1)
	_mensagem_tween.interpolate_property(_mensagem, "scale", Vector2(.4, .4), Vector2(.6, .6), 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	_mensagem_tween.interpolate_property(_mensagem, "position", Vector2(0, -5), Vector2(0, -12), .1)
	_mensagem_tween.start()
	_timer_esconder_mens.start()


func tocar_som(som: AudioStreamSample) -> void:
	$SomItem.stream = som
	$SomItem.play()


func esconder_mensagem() -> void:
	_mensagem_tween.interpolate_property(_mensagem, "modulate", Color.white, Color.transparent, .1)
	_mensagem_tween.interpolate_property(_mensagem, "scale", Vector2(.6, .6), Vector2(.4, .4), .1)
	_mensagem_tween.interpolate_property(_mensagem, "position", Vector2(0, -12), Vector2(0, -19), .1)
	_mensagem_tween.start()


func _definir_ativo(v: bool) -> void:
	._definir_ativo(v)
	raycast_inimigo.enabled = v
	
	if not v:
		if not _timer_esconder_mens.is_stopped():
			_timer_esconder_mens.stop()
			esconder_mensagem()
		
		_desativar_termometro_seta("seta")
		_fim_buff_cafe()
