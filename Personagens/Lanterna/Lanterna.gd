extends Node2D

onready var luz_cone = $LuzCone
onready var luz_em_volta = $LuzEmVolta
onready var luz_revelador = $ReveladorInimigo

export(float) var bateria = 60 setget _set_bateria
# Settar a max_bateria como a bateria pro player ja começar com a max bateria
# e pra dar de settar um outro valor mais rapido pelo editor
var max_bateria: float = bateria
var ligada: bool = false setget _set_ligada
# Variaveis da lanterna piscando
var piscando: bool = false
var apagada: bool = false


func _process(delta: float) -> void:
	# Player liga ou desliga a lanterna
	if Input.is_action_just_pressed("ativar_desativar_lanterna"):
		_set_ligada(!ligada)
	
	# Segue o mouse
	look_at(get_global_mouse_position())
	# Se estiver ligada gasta bateria
	if ligada:
		_set_bateria(bateria - delta)
		
		# Força da luz da lanterna diminui junto com a bateria
		if bateria < max_bateria * 0.4 and not piscando:
			piscando = true
			randomize()
			$LanternaPiscaTimer.start(rand_range(0.05, 0.3))
			luz_cone.enabled = false
			luz_em_volta.enabled = false
			apagada = true
		# Caso a bateria acabe a lanterna desliga
		if bateria <= 0:
			_set_ligada(false)


func _set_ligada(new: bool) -> void:
	# Retorna caso n tenha bateria e o player tente ligar
	if new == true and bateria < 0:
		return
	
	ligada = new
	# Caso novo valor for true fica visivel, caso for false não fica visivel
	luz_cone.enabled = new
	luz_em_volta.enabled = new
	luz_revelador.enabled = new


# Faz a luz piscar
func _on_LanternaPiscaTimer_timeout() -> void:
	if ligada:
		# Caso esteja apagada ela acende e liga o timer pra apagar dnv
		if apagada:
			luz_cone.enabled = true
			luz_em_volta.enabled = true
			apagada = false
			$LanternaPiscaTimer.start(rand_range(1, 4))
		# Desliga o piscando fazendo com que ela apague dnv
		else:
			piscando = false


# Recarrega td a bateria e reseta tds as variaveis da lanterna piscando
func _recarregar():
	piscando = false
	apagada = false
	
	_set_bateria(max_bateria)
	_set_ligada(true)
	
	$LanternaPiscaTimer.stop()


# Setter da bateria pra evitar problemas mechendo com o power bank
func _set_bateria(new_value) -> void:
	if new_value > max_bateria:
		bateria = max_bateria
	elif new_value < 0:
		bateria = 0
	else:
		bateria = new_value
	
	luz_cone.energy = clamp((bateria / (max_bateria / 100)) / 100, .5, 1)
