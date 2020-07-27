extends Area2D

var max_iteracoes
var iteracoes = 0
var tempo_de_stun


func _on_Timer_timeout():
	iteracoes += 1
	if iteracoes > max_iteracoes:
		self.queue_free()
	
	var novo_sprite = $Sprite.duplicate()
	call_deferred("add_child", novo_sprite)
	novo_sprite.position = Vector2(iteracoes * 8, 0)
	randomize()
	novo_sprite.position.y = rand_range(-1, 1)
	$CollisionShape2D.scale.x += 1
	$CollisionShape2D.position.x += 4


func _on_RaioTaser_collision(body: Node):
	# Dois testes so pra ter certeza
	if body.is_in_group("inimigo") and body.has_method("stunar"):
		body.stunar(tempo_de_stun)
