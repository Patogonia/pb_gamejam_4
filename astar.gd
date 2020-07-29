extends TileMap

export(bool) var mostrar_nos

var _astar: AStar2D
var _andavel: Array = []
var _obstaculos: Array = []
var _retangulo_mapa: Rect2

func _ready() -> void:
	Globais.mapa_pathfinding = self
	
	_retangulo_mapa = get_used_rect()
	_astar = AStar2D.new()
#	_astar.reserve_space(int(_retangulo_mapa.size.x * _retangulo_mapa.size.y))
	
	# Pegar celulas marcadas como obstaculos
	_obstaculos = get_used_cells_by_id(0)
	
	# Pegar celulas marcadas com nada, adicionar elas ao astar e ao _andavel
	var inicio: Vector2 = _retangulo_mapa.position
	var fim: Vector2 = _retangulo_mapa.end
	
	for y in range(inicio.y, fim.y):
		for x in range(inicio.x, fim.x):
			var celula = Vector2(x, y)
			# Esta celula e um obstaculo, ignora ela
			if celula in _obstaculos:
				continue
			
			_andavel.append(celula)
			_astar.add_point(_calcular_indice_celula(celula), celula, 1)
	
	# Conectar celulas andaveis
	# E possivel que o caminho gerado siga diagonais, ent o caso abaixo e possivel:
	# O caminho vai passar por aqueles dois o
	for celula in _andavel:
		var i_celula = _calcular_indice_celula(celula)
		
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				var celula_vizinha: Vector2 = celula + Vector2(x, y)
				var i_celula_vizinha: int = _calcular_indice_celula(celula_vizinha)
				
				# Nao conectar celulas diagonais que possuem algum obstaculo que possa ser inconveniente, como no caso abaixo:
				# x - obstaculo
				# o - celula
				# v - celula vizinha
				# _ - espaco em branco
				# x v ou x v ou _ v etc.
				# o x    o _    o x
				if x != 0 and y != 0:
					var i_cel_viz_1 = _calcular_indice_celula(celula + Vector2(x, 0))
					var i_cel_viz_2 = _calcular_indice_celula(celula + Vector2(0, y))
					
					if not _astar.has_point(i_cel_viz_1) or not _astar.has_point(i_cel_viz_2):
						continue
				
				if celula_vizinha == celula or not _astar.has_point(i_celula_vizinha):
					continue

				_astar.connect_points(i_celula, i_celula_vizinha, true)

func _calcular_indice_celula(celula: Vector2) -> int:
	var inicio: Vector2 = _retangulo_mapa.position
	return int((celula.x - inicio.x) + (celula.y - inicio.y) * _retangulo_mapa.size.x)


func _celula_esta_fora_mapa(celula: Vector2) -> bool:
	var inicio: Vector2 = _retangulo_mapa.position
	var fim: Vector2 = _retangulo_mapa.end
	return celula.x < inicio.x or celula.x > fim.x or celula.y < inicio.y or celula.y > fim.y


# Retorna o caminho entre inicio e fim
# As coordenadas dos parametros e do valor de retorno sao em relacao ao mapa
func _pegar_caminho_coords_mapa(inicio: Vector2, fim: Vector2) -> PoolVector2Array:
	var i_inicio: int = _calcular_indice_celula(inicio)
	var i_fim: int = _calcular_indice_celula(fim)
	
	if not _astar.has_point(i_inicio):
		printerr("Ponto inicio ", i_inicio, " nao eh andavel ou nao pertence ao mapa")
	if not _astar.has_point(i_fim):
		printerr("Ponto fim ", i_fim, " nao eh andavel ou nao pertence ao mapa")
	
	return _astar.get_point_path(i_inicio, i_fim)


# Retorna o caminho entre inicio e fim
# As coordenadas dos parametros e do valor de retorno sao em relacao ao mundo
func pegar_caminho_coords_mundo(inicio: Vector2, fim: Vector2) -> PoolVector2Array:
	var inicio_grade: Vector2 = _astar.get_point_position(_astar.get_closest_point(world_to_map(inicio)))
	var fim_grade: Vector2 = _astar.get_point_position(_astar.get_closest_point(world_to_map(fim)))
	var caminho: PoolVector2Array = _pegar_caminho_coords_mapa(inicio_grade, fim_grade)
	
	for i in range(caminho.size()):
		caminho[i] = map_to_world(caminho[i]) + cell_size * .5
	
	return caminho


func _draw() -> void:
	if mostrar_nos:
		for no in _astar.get_points():
			draw_circle(map_to_world(_astar.get_point_position(no)) + cell_size * .5, 5, Color.black)
