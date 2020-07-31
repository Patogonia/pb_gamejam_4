extends Node

export(float) var tempo_spawnar: float
var inimigo

func _ready() -> void:
	if get_child_count() == 0:
		printerr("Nao existe spawns.")
		return
	
	inimigo = $Inimigo
	inimigo.ativo = false
	remove_child(inimigo)
	
	get_tree().create_timer(tempo_spawnar).connect("timeout", self, "_spawnar_inimigo")


func _spawnar_inimigo() -> void:
	var spawn: Vector2 = Vector2.ZERO
	
	if get_child_count() == 0:
		printerr("Nao tem spawn, spawnado ele na pos 0, 0")
	elif get_child_count() == 1:
		spawn = get_child(0).position
	else:
		var spawns: Array = get_children()
		var spawn_mais_perto_jog: Node2D = spawns.pop_front()
		var pos_jog: Vector2 = Globais.jogador.position
		var dist_spawn_mais_perto_jog: float = spawn_mais_perto_jog.position.distance_squared_to(pos_jog)
		
		for s in spawns:
			var dist: float = s.position.distance_squared_to(pos_jog)
			if dist < dist_spawn_mais_perto_jog:
				dist_spawn_mais_perto_jog = dist
				spawn_mais_perto_jog = s
		
		var spawns_desejaveis: Array = get_children()
		spawns_desejaveis.erase(spawn_mais_perto_jog)
		randomize()
		spawn = spawns_desejaveis[randi() % spawns_desejaveis.size()].position
	
	inimigo.position = spawn
	$"../YSort".add_child(inimigo)
	inimigo.ativo = true
	
	Globais.jogador.mostrar_mensagem("Sneaky boy arrived! He must not get %d HDs!" % (inimigo.qnt_alvos))
	
	for p in get_children():
		p.queue_free()
