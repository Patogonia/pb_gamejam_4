extends KinematicBody2D

export(float) var velocidade_maxima
export(float) var aceleracao 

var _direcao: Vector2 = Vector2.ZERO
var _velocidade: Vector2

var lado = "direita"

func _physics_process(delta: float):
	# Pegar direcao
	_direcao.x = int(Input.is_action_pressed("andar_pra_direita")) - int(Input.is_action_pressed("andar_pra_esquerda"))
	_direcao.y = int(Input.is_action_pressed("andar_pra_baixo")) - int(Input.is_action_pressed("andar_pra_cima"))
	_direcao = _direcao.normalized()
	
	# Vira o personagem baseado na direcao q ele ta andando
	_virar_personagem(_direcao.x)
	
	# Aplicar velocidade
	var vel_alvo: Vector2 = _direcao * velocidade_maxima
	var vel_interp: Vector2 = _velocidade.linear_interpolate(vel_alvo, aceleracao * delta)
	_velocidade = move_and_slide(vel_interp, Vector2.UP)


func _virar_personagem(direcao: float):
	if direcao > 0:
		$Sprite.flip_h = false
	elif direcao < 0:
		$Sprite.flip_h = true
