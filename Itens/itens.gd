extends Node

export(int) var usos
export(String) var mensagem_usar

var _jogador
var item_index
var inventario


func _use(novo_jogador) -> void:
	_jogador = novo_jogador
	# Ativa o efeito do item e usa um uso dele
	_efeito()
	usos -= 1
	
	if not mensagem_usar.empty():
		_jogador.mostrar_mensagem(mensagem_usar)
	
	if usos <= 0:
		inventario._matar_item(self)


# Efeito do item
func _efeito() -> void:
	pass
