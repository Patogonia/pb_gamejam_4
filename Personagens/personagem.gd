extends KinematicBody2D

export(float) var velocidade_maxima
export(float) var aceleracao 

onready var _sprite: AnimatedSprite = $Sprite

var _direcao: Vector2 = Vector2.ZERO
var _velocidade: Vector2


func _physics_process(delta: float) -> void:
	# Aplicar velocidade
	var vel_alvo: Vector2 = _direcao * velocidade_maxima
	var vel_interp: Vector2 = _velocidade.linear_interpolate(vel_alvo, aceleracao * delta)
	_velocidade = move_and_slide(vel_interp, Vector2.UP)
	
	_virar_personagem(_direcao.x)
	_sprite.play("andando" if _direcao.x != 0 or _direcao.y != 0 else "parado")


func _virar_personagem(direcao: float) -> void:
	if direcao > 0:
		_sprite.flip_h = false
	elif direcao < 0:
		_sprite.flip_h = true
