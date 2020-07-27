extends Node

export(int) var usos

var _jogador


func _use() -> void:
	# Ativa o efeito do item e usa um uso dele
	_efeito()
	usos -= 1
	if usos <= 0:
		self.queue_free()


# Efeito do item
func _efeito() -> void:
	pass
