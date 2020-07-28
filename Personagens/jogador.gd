extends "res://Personagens/personagem.gd"

onready var raycast_inimigo: RayCast2D = $RaycastInimigo

export(NodePath) var caminho_inimigo

var _inimigo: Node2D

var velocidade_maxima_original
var posicao_armadilha = Vector2(0, 0)


func _ready() -> void:
	_inimigo = get_node(caminho_inimigo)
	velocidade_maxima_original = velocidade_maxima


func _physics_process(_d: float) -> void:
	# Pegar direcao
	_direcao.x = int(Input.is_action_pressed("andar_pra_direita")) - int(Input.is_action_pressed("andar_pra_esquerda"))
	_direcao.y = int(Input.is_action_pressed("andar_pra_baixo")) - int(Input.is_action_pressed("andar_pra_cima"))
	_direcao = _direcao.normalized()
	
	if is_instance_valid(_inimigo):
		raycast_inimigo.cast_to = position.direction_to(_inimigo.position) * 8
		var colisor = raycast_inimigo.get_collider()
		if colisor:
			colisor.queue_free()
	
	$SetaArmadilha.look_at(posicao_armadilha)


func _fim_buff_cafe():
	self.velocidade_maxima = velocidade_maxima_original


func _armadilha_ativada(nova_posicao_armadilha):
	posicao_armadilha = nova_posicao_armadilha
	$SetaArmadilha.visible = true
	get_tree().create_timer(7).connect("timeout", self, "_desativar_termometro_seta", ["seta"])


func _termometro(is_quente: bool):
	$Label.visible = true
	$Label.text = "HOT" if is_quente else "COLD"
	get_tree().create_timer(2).connect("timeout", self, "_desativar_termometro_seta", ["termometro"])


func _desativar_termometro_seta(qual: String):
	if qual == "termometro":
		$Label.visible = false
	elif qual == "seta":
		$SetaArmadilha.visible = false
