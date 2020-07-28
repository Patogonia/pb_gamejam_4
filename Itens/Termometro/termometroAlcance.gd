extends Area2D

signal termometro_usado


func _on_TermometroAlcance_body_entered(body):
	emit_signal("termometro_usado", true)
	self.queue_free()


func _on_Timer_timeout():
	emit_signal("termometro_usado", false)
	self.queue_free()
