extends Node

const _NOME_ARQUIVO: String = "user://tosneakyforu.save"
const _TEMPLATE: Dictionary = {
	"Outside": 0,
	"TheBuilding": 0,
}

var save_carregado: Dictionary

func _ready() -> void:
	save_carregado = carregar_save()


func salvar_pontuacao(mapa: String, tempo: int) -> void:
	if tempo < save_carregado[mapa] or save_carregado[mapa] == 0:
		save_carregado[mapa] = tempo
	
	var arquivo := File.new()
	var erro: int = arquivo.open(_NOME_ARQUIVO, File.WRITE)
	if not erro:
		arquivo.store_line(JSON.print(save_carregado))
	arquivo.close()


func carregar_save() -> Dictionary:
	var arquivo := File.new()
	
	if not arquivo.file_exists(_NOME_ARQUIVO):
		return _TEMPLATE
	
	var erro: int = arquivo.open(_NOME_ARQUIVO, File.READ)
	
	if not erro:
		var json: JSONParseResult = JSON.parse(arquivo.get_as_text())
		if not json.error:
			arquivo.close()
			return json.result
		
	arquivo.close()
	return _TEMPLATE
	
