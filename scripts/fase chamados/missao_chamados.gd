class_name QuestChamados
extends Quest

var target_count: int = 3
var current_count: int = 0

var npcs_resolvidos: Array[String] = []

# Mapeamento dos setores e o item que cada um exige
var problemas_npcs: Dictionary = {
	"Recepcao": {"item_necessario": "mouse_novo", "chamado_aberto": false},
	"RH": {"item_necessario": "memoria_ram", "chamado_aberto": false},
	"Almoxarifado": {"item_necessario": "cabo_rede", "chamado_aberto": false}
}

func _init() -> void:
	id = "atender_chamados"
	title = "Atenda os chamados dos funcionários"
	description = "Converse com os funcionários, pegue as peças necessárias na bancada e resolva os problemas."
	estado_atual = "em_andamento"

func abrir_chamado(setor: String) -> void:
	if problemas_npcs.has(setor):
		problemas_npcs[setor]["chamado_aberto"] = true
		print("[QUEST] Chamado ABERTO para o setor: ", setor, " | Item pendente: ", problemas_npcs[setor]["item_necessario"])

# Retorna qual item está faltando coletar com base nos chamados abertos
func obter_proximo_item_pendente() -> String:
	for setor in problemas_npcs.keys():
		var dados = problemas_npcs[setor]
		var item = dados["item_necessario"]
		
		# Se o chamado foi aberto, o setor ainda não foi resolvido E o jogador não tem o item no inventário
		if dados["chamado_aberto"] and not esta_resolvido(setor) and not Globals.possui_item(item):
			return item
	return ""

func progredir(dados: Dictionary = {}) -> void:
	if estado_atual == "finalizada":
		return
		
	var setor: String = dados.get("setor", "")
	
	if setor != "" and not npcs_resolvidos.has(setor):
		npcs_resolvidos.append(setor)
		current_count = clampi(npcs_resolvidos.size(), 0, target_count)
		
		em_andamento.emit(id)
		print("Chamados resolvidos: ", current_count, "/", target_count)
		
		if current_count >= target_count:
			finalizar()

func finalizar() -> void:
	estado_atual = "finalizada"
	finalizada.emit(id)

func esta_resolvido(setor: String) -> bool:
	return npcs_resolvidos.has(setor)
