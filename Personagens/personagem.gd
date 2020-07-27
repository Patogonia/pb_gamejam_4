extends KinematicBody2D

export(float) var velocidade_maxima
export(float) var aceleracao 

onready var _sprite: Sprite = $Sprite

var _direcao: Vector2 = Vector2.ZERO
var _velocidade: Vector2

var lado = "direita"

func _physics_process(delta: float) -> void:
	# Aplicar velocidade
	var vel_alvo: Vector2 = _direcao * velocidade_maxima
	var vel_interp: Vector2 = _velocidade.linear_interpolate(vel_alvo, aceleracao * delta)
	_velocidade = move_and_slide(vel_interp, Vector2.UP)
	
	_virar_personagem(_direcao.x)


func _virar_personagem(direcao: float):
	if direcao > 0:
		$Sprite.flip_h = false
	elif direcao < 0:
		$Sprite.flip_h = true
