extends Node


func _ready() -> void:
	if not Globais.inimigo:
		printerr("Nao foi possivel achar inimigo. Verifique se esse node vem depois do inimigo, ou se o inimigo existe")
		return
	
	if get_child_count() == 0:
		printerr("Nao existe spawns.")
		return
	
	randomize()
	var spawn: Vector2 = get_children()[randi() % get_child_count()].position
	Globais.inimigo.position = spawn
	
	queue_free()
