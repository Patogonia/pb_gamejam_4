extends Node

export(String) var item_to_instance

var jogador
var jogador_na_area: bool = false



func _process(_delta: float) -> void:
	# Se o jogador clicar o botao de interagir e estiver na area da mesa ele recarrega a bateria
	var novo_espaco = Globais.inventario._espaco_novo_item()
	if Input.is_action_just_pressed("interagir") and jogador_na_area and novo_espaco != null:
		_dar_item(novo_espaco)
		$BotaoSprite.frame = 0
		$BotaoSprite.play("default")


func _dar_item(index):
	var item_instance = load(item_to_instance).instance()
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


# Quando o jogador entra na area da mesa a variavel fica true pra ele poder interagir
func _on_Area2D_body_entered(body) -> void:
	jogador = body
	jogador_na_area = true
	$BotaoSprite.visible = true


# Quando o jogador sai da area da mesa a variavel fica false pra ele n poder interagir
func _on_Area2D_body_exited(_body) -> void:
	jogador_na_area = false
	$BotaoSprite.visible = false


# Mudar a posição do label pra ele seguir a animação do botao
func _on_BotaoSprite_frame_changed():
	if $BotaoSprite.frame == 0:
		$BotaoSprite/Label.rect_position.y = -7
	elif $BotaoSprite.frame == 4:
		$BotaoSprite/Label.rect_position.y = -7
		$BotaoSprite.stop()
	else:
		$BotaoSprite/Label.rect_position.y = -5
