extends Node2D 

var ja_coletado = false

func _ready():
	# Busca a Area2D que está logo abaixo deste nó e conecta o sinal dela
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player") and not ja_coletado and QuestManager.quests["identificar_riscos"]["started"]:
		if QuestManager.quests["identificar_riscos"]["current_step"] == 0:
			ja_coletado = true
			QuestManager.progress_quest("identificar_riscos")
			
			# Isso vai deletar o nó 'Risco' e TODOS os filhos dele juntos!
			queue_free()
