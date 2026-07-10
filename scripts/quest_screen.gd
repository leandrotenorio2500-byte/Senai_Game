extends Control
class_name MissionScreen

# Referências baseadas na estrutura da sua cena
@onready var _title: Label = $HBoxContainer/VBoxContainer/Title
@onready var _subtitle: Label = $HBoxContainer/VBoxContainer/Subtitle

func _ready() -> void:
	# Garante que os nós existem ao iniciar
	if _title == null or _subtitle == null:
		push_error("MissionScreen: Nós de texto não encontrados na árvore de cena!")

# Função chamada pelo QuestManager para atualizar os textos visualizados
func update_display(quest_id: String) -> void:
	var missao = QuestManager.missao_atual
	
	# Se não houver missão ativa ou o ID não bater, não faz nada
	if missao == null or missao.id != quest_id:
		return
		
	# Define o título principal da missão pegando direto do objeto
	_title.text = missao.title
	
	# Como a nova arquitetura suporta scripts customizados para cada missão, 
	# nós verificamos se a missão atual possui propriedades de contador (como a de riscos)
	if "current_count" in missao and "target_count" in missao:
		# Se tiver contador, mostra a descrição e o progresso ex: "Encontre os pontos de risco no mapa (1/3)"
		_subtitle.text = missao.description + " (" + str(missao.current_count) + "/" + str(missao.target_count) + ")"
	else:
		# Se for uma missão sem contador (ex: apenas falar com alguém), mostra só a descrição
		_subtitle.text = missao.description
