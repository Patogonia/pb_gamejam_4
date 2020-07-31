extends TileMap

const _RAIO_PESO: int = 6
const _PESO_EXTRA: float = 3.0

export(bool) var mostrar_nos
export(bool) var mostrar_nos_perto_jogador

var _astar: AstarNovo
var _andavel: Array = []
var _obstaculos: Array = []
var _nos_perto_jogador: Array = []
var _retangulo_mapa: Rect2

class AstarNovo extends AStar2D:
	var fugindo: bool = false
	var pos_jog: Vector2 = Vector2.ZERO
	
	func _compute_cost(de_id: int, para_id: int) -> float:
		var de_pos: Vector2 = get_point_position(de_id)
		var para_pos: Vector2 = get_point_position(para_id)
		# Adicionar custo para celulas que estao perto 
		var custo_extra: float = 0.0 if not fugindo else de_pos.distance_squared_to(pos_jog)
		
		return de_pos.distance_to(para_pos) + custo_extra
	
	
	func _estimate_cost(de_id: int, para_id: int) -> float:
		var de_pos: Vector2 = get_point_position(de_id)
		var para_pos: Vector2 = get_point_position(para_id)
		
		return de_pos.distance_to(para_pos)


func _ready() -> void:
	Globais.mapa_pathfinding = self
	
	_retangulo_mapa = get_used_rect()
	_astar = AstarNovo.new()
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
func _pegar_caminho_coords_mapa(inicio: Vector2, fim: Vector2, fugindo: bool = false) -> PoolVector2Array:
	var i_inicio: int = _calcular_indice_celula(inicio)
	var i_fim: int = _calcular_indice_celula(fim)
	
	if not _astar.has_point(i_inicio):
		printerr("Ponto inicio ", i_inicio, " nao eh andavel ou nao pertence ao mapa")
	if not _astar.has_point(i_fim):
		printerr("Ponto fim ", i_fim, " nao eh andavel ou nao pertence ao mapa")
	
	_astar.fugindo = fugindo
	_astar.pos_jog = Globais.jogador.position
	
	return _astar.get_point_path(i_inicio, i_fim)


# Retorna o caminho entre inicio e fim
# As coordenadas dos parametros e do valor de retorno sao em relacao ao mundo
func pegar_caminho_coords_mundo(inicio: Vector2, fim: Vector2, fugindo: bool = false) -> PoolVector2Array:
	var inicio_grade: Vector2 = _astar.get_point_position(_astar.get_closest_point(world_to_map(inicio)))
	var fim_grade: Vector2 = _astar.get_point_position(_astar.get_closest_point(world_to_map(fim)))
	var caminho: PoolVector2Array = _pegar_caminho_coords_mapa(inicio_grade, fim_grade, fugindo)
	
	for i in range(caminho.size()):
		caminho[i] = map_to_world(caminho[i]) + cell_size * .5
	
	return caminho


func _draw() -> void:
	if mostrar_nos:
		for no in _astar.get_points():
			if _astar.get_point_weight_scale(no) != 1.0:
				draw_circle(map_to_world(_astar.get_point_position(no)) + cell_size * .5, 5, Color.yellow)
			else:
				draw_circle(map_to_world(_astar.get_point_position(no)) + cell_size * .5, 5, Color.black if _astar.get_point_weight_scale(no) == 1.0 else Color.yellow)


# Atualiza pesos a cada x segundos definida no timer
# Isso daq aumenta o peso de nos perto do jogador
# Dai o inimigo vai gerar caminhos que evitam o jogador
# Tambem deve melhorar o pathfinding quando ele tenta fugir do jogador
func _atualizar_pesos():
	for no in _nos_perto_jogador:
		_astar.set_point_weight_scale(no, 1)
	
	_nos_perto_jogador.clear()
	
	var pos_jog: Vector2 = _astar.get_point_position(_astar.get_closest_point(world_to_map(Globais.jogador.position)))
	# Isso daq itera sobre elementos i, j de um circulo
	for y in range(-_RAIO_PESO, _RAIO_PESO):
		var dx = int(sqrt(_RAIO_PESO * _RAIO_PESO - y * y))
		for x in range(-dx, dx):
			var i_no: int = _calcular_indice_celula(pos_jog + Vector2(x, y))
			if _astar.has_point(i_no):
				_nos_perto_jogador.append(i_no)
				_astar.set_point_weight_scale(i_no, _PESO_EXTRA)
	
	update()


# Este pegador de pontos em uma circunferencia n e mto boa
# porem, funciona para o caso do inimigo achar uma posicao a uma distancia especifica
# quando ele ta fugindo do jogador
func pegar_pontos_em_circunferencia_mapa(c: Vector2, r: float) -> PoolVector2Array:
	var res: PoolVector2Array = []
	var c_ponto: Vector2 = _astar.get_point_position(_astar.get_closest_point(c))
	
	for y in range(-r, r):
		var dx = int(sqrt(r * r - y * y))
		var p1: Vector2 = c_ponto + Vector2(-dx, y)
		var p2: Vector2 = c_ponto + Vector2(dx, y)
		
		if _astar.has_point(_calcular_indice_celula(p1)):
			res.push_back(p1)
		if _astar.has_point(_calcular_indice_celula(p2)):
			res.push_back(p2)
	
	return res


func pegar_pontos_em_circunferencia_mundo(c: Vector2, r: float) -> PoolVector2Array:
	var c_mapa: Vector2 = world_to_map(c)
	var r_mapa: float = r * 0.0625 # = r / 16
	var res: PoolVector2Array = pegar_pontos_em_circunferencia_mapa(c_mapa, r_mapa)

	for i in range(res.size()):
		res[i] = map_to_world(res[i]) + cell_size * .5
	
	return res
