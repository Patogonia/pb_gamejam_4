extends "res://Itens/mesa.gd"

const CAFE_JAVA = preload("res://Itens/Cafe/CafeJava.tscn")


func _dar_item(index):
	randomize()
	var item_instance
	if rand_range(0, 100) <= 5:
		item_instance = CAFE_JAVA.instance()
		mensagem_pegar = "Acquired Cursed Programming Language"
	else:
		item_instance = load(item_to_instance).instance()
		mensagem_pegar = "Acquired Programmer Drink!"
	# Setta o index no inventario do item
	item_instance.item_index = index
	# Adiciona ele no lugar dele no invetario
	Globais.inventario.get_node("Item" + str(index + 1)).add_child(item_instance)
	# Setta na posição 0 no node pai dele
	item_instance.position = Vector2(0, 0)
	# Da a referencia pro inventario pro item
	item_instance.inventario = Globais.inventario
	# Adiciona no array inventario
	Globais.inventario.itens[index] = item_instance
