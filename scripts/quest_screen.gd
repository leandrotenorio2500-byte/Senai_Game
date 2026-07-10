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
		
	# Define o título principal da missão pegando direto do objeto ativo
	_title.text = missao.title
	
	# --- CONDIÇÃO PARA MISSÕES COM SISTEMA DE COLETA / CONTADOR ---
	if "current_count" in missao and "target_count" in missao:
		# Se a missão tiver variáveis numéricas de contagem, adiciona o sufixo (X/Y)
		_subtitle.text = missao.description + " (" + str(missao.current_count) + "/" + str(missao.target_count) + ")"
	
	# --- CONDIÇÃO PARA MISSÕES NORMAIS (Diálogos, ir até um local, etc.) ---
	else:
		# Se for uma missão sem coleta, exibe apenas o texto direto da descrição
		_subtitle.text = missao.description
