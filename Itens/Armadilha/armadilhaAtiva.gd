extends Area2D

signal inimigo_detectado


func _on_ArmadilhaAtiva_body_entered(body):
	# Ativa o raycast vira ele pra direcao do inimigo e checka pra ver se tem um muro na frente
	var estado_espaco = get_world_2d().direct_space_state
	var resultado: Dictionary = estado_espaco.intersect_ray(position, body.position, [self], 6)

	if resultado.collider == body:
		emit_signal("inimigo_detectado", position)
		queue_free()
