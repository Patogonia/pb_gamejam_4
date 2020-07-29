extends Area2D

const MENSAGEM_FRIO: String = "Red thingy is low :("
const MENSAGEM_QUENTE: String = "Red thingy is high! :O"

var jogador

func _on_TermometroAlcance_body_entered(body):
	jogador.mostrar_mensagem(MENSAGEM_QUENTE)
	self.queue_free()


func _on_Timer_timeout():
	jogador.mostrar_mensagem(MENSAGEM_FRIO)
	self.queue_free()
