extends HBoxContainer

var _jogador
var itens: Array = [
	null,
	null
]


# Pega o node do jogador pra dar pros itens depois
func _ready():
	_jogador = get_parent().get_node("../Jogador")


func _process(_delta: float) -> void:
	# Se clicar o botao e o item existir ele usa o item
	if Input.is_action_just_pressed("item1") and itens[0] != null:
		itens[0]._use(_jogador)
	
	if Input.is_action_just_pressed("item2") and itens[1] != null:
		itens[1]._use(_jogador)


# Checka se tem espaco pra um novo item, se n tiver retorna false, se tiver retorna o index do array
func _espaco_novo_item():
	if itens[0] == null:
		return 0
	elif itens[1] == null:
		return 1
	else:
		return null


# Tira o item do array e mata ele
func _matar_item(item):
	itens[item.item_index] = null
	item.queue_free()
