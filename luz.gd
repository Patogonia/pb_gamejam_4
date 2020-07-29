extends Light2D


func _ready() -> void:
	var revelador: Light2D = $ReveladorInimigo
	revelador.texture = texture
	revelador.energy = energy
	revelador.color = color
