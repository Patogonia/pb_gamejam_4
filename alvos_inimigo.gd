extends Node


func _ready() -> void:
	Globais.alvos = self


# Pega o melhor alvo para o inimigo
# O melhor alvo sera aquele que e o mais proximo ao inimigo, e mais longe do jogador
func pegar_alvo() -> Node2D:
	var qnt_alvos: int = get_child_count()
	
	# Retornar um erro se algum imbecil esqueceu de setar alvos
	if qnt_alvos == 0:
		printerr("Nao existe alvo")
		return null
	
	# Retornar direto o unico alvo que da pra pegar
	if qnt_alvos == 1:
		return get_child(0) as Node2D
	
	# Pegar os alvos, e colocar eles em um dicionario associado a sua pontuacao de melhor alvo
	# O melhor alvo eh 1/distancia_alvo_inimigo - distancia_alvo_jogador
	# Ou seja, quanto mais do inimigo e mais longe do jogador, maior sua pontuacao
	# Sera retornado o alvo que possui a maior pontuacao
	var pontuacao_alvos: Dictionary = {}
	var menor_d_a_j: float = 0
	var alvo_menor_d_a_j: Node2D = null
	var d_a_i_alvo_menor_d_a_j: float = 0
	
	for alvo in get_children():
		var pos_alvo: Vector2 = alvo.position
		var d_a_j: float = Globais.jogador.position.distance_squared_to(pos_alvo)
		var d_a_i: float = Globais.inimigo.position.distance_squared_to(pos_alvo)
		
		pontuacao_alvos[alvo] = 100 / d_a_i - 100 / d_a_j
#		print(alvo.name, " ", pontuacao_alvos[alvo])
		
		if not alvo_menor_d_a_j or d_a_j < menor_d_a_j:
			alvo_menor_d_a_j = alvo
			menor_d_a_j = d_a_j
			d_a_i_alvo_menor_d_a_j = d_a_i
	
	# Remover o alvo mais proximo do jogador, se ele estiver proximo o suficiente
	# e se a distancia entre este alvo e o inimigo eh maior que sua distancia com o jogador
	if menor_d_a_j < 50*50 and d_a_i_alvo_menor_d_a_j > menor_d_a_j:
		pontuacao_alvos.erase(alvo_menor_d_a_j)
	if pontuacao_alvos.size() == 1:
		return pontuacao_alvos.values()[0]
	
	# Retornar o alvo com a maior pontuacao
	var alvos: Array = pontuacao_alvos.keys()
	var melhor_alvo: Node2D = alvos.pop_front()
	for alvo in alvos:
		if pontuacao_alvos[alvo] > pontuacao_alvos[melhor_alvo]:
			melhor_alvo = alvo
	
	return melhor_alvo


func _ordenar_por_pontuacao(a: int, b: int):
	return a > b
