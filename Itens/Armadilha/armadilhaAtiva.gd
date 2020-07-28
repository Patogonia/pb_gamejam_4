extends Area2D

signal inimigo_detectado


func _on_ArmadilhaAtiva_body_entered(body):
	# Ativa o raycast vira ele pra direcao do inimigo e checka pra ver se tem um muro na frente
	$RayCast2D.enabled = true
	$RayCast2D.look_at(body)
	if $RayCast2D.get_collider() == body:
		emit_signal("inimigo_detectado", self.position)
	$RayCast2D.enabled = false
