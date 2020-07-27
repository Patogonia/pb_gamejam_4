extends Node2D

export(float, 0, 100) var bateria = 60
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
		bateria -= delta
		# Força da luz da lanterna diminui junto com a bateria
		if $Light2D.energy > 0.5:
			$Light2D.energy = (bateria / (max_bateria / 100)) / 100
		elif bateria < max_bateria * 0.4 and not piscando:
			piscando = true
			randomize()
			$LanternaPiscaTimer.start(rand_range(0.05, 0.3))
			$Light2D.enabled = false
			apagada = true
		# Caso a bateria acabe a lanterna desliga
		if bateria <= 0:
			bateria = 0
			_set_ligada(false)


func _set_ligada(new: bool) -> void:
	# Retorna caso n tenha bateria e o player tente ligar
	if new == true and bateria < 0:
		return
	
	ligada = new
	# Caso novo valor for true fica visivel, caso for false não fica visivel
	$Light2D.enabled = new


# Faz a luz piscar
func _on_LanternaPiscaTimer_timeout() -> void:
	if ligada:
		# Caso esteja apagada ela acende e liga o timer pra apagar dnv
		if apagada:
			$Light2D.enabled = true
			apagada = false
			$LanternaPiscaTimer.start(rand_range(1, 4))
		# Desliga o piscando fazendo com que ela apague dnv
		else:
			piscando = false


# Recarrega td a bateria e reseta tds as variaveis da lanterna piscando
func _recarregar():
	bateria = max_bateria
	$LanternaPiscaTimer.stop()
	piscando = false
	apagada = false
	$Light2D.enabled = ligada
	$Light2D.energy = 1
