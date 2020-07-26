extends Node2D

export(float, 0, 100) var bateria = 100
var ligada: bool = false setget _set_ligada


func _process(delta: float):
	# Player liga ou desliga a lanterna
	if Input.is_action_just_pressed("ativar_desativar_lanterna"):
		_set_ligada(!ligada)
	
	# Segue o mouse
	look_at(get_global_mouse_position())
	# Se estiver ligada gasta bateria
	if ligada:
		bateria -= delta
		# Caso bateria acabe ele desliga a lanterna
		if bateria <= 0:
			bateria = 0
			_set_ligada(false)


func _set_ligada(new: bool):
	# Retorna caso n tenha bateria e o player tente ligar
	if new == true and bateria < 0:
		return
	
	ligada = new
	# Caso novo valor for true fica visivel, caso for false não fica visivel
	$Light2D.enabled = new
	# Desrotacionar quando desligada
	if new == false:
		self.rotation_degrees = 0
