extends "res://Itens/mesa.gd"

var quantidade_ativa = 0


func _dar_item(index):
	if quantidade_ativa < 2:
		quantidade_ativa += 1
		var item_instance = load(item_to_instance).instance()
		# Setta o index no inventario do item
		item_instance.item_index = index
		# Adiciona ele no lugar dele no invetario
		inventario.get_node("Item" + str(index + 1)).add_child(item_instance)
		# Setta na posição 0 no node pai dele
		item_instance.position = Vector2(0, 0)
		# Da a referencia pro inventario pro item
		item_instance.inventario = self.inventario
		# Adiciona no array inventario
		inventario.itens[index] = item_instance
		# Setta uma referencia pra essa mesa
		item_instance.mesa = self


func _mesa_desativada(_posicao_armadilha):
	quantidade_ativa -= 1
