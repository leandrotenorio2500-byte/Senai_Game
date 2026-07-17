extends Node

# Nome da skin atual
var current_skin: String = "string"

# Dicionário que mapeia o nome da skin para o caminho do arquivo .tres correspondente
var skins = {
	"default": "res://sprites/skin_changer/player.tres",
	"npc_6": "res://sprites/skin_changer/npc_6.tres",
}

# Retorna o recurso SpriteFrames da skin ativa
func get_current_sprite_frames() -> SpriteFrames:
	if skins.has(current_skin):
		return load(skins[current_skin]) as SpriteFrames
	
	# Caso dê algum erro, carrega a padrão
	return load(skins["default"]) as SpriteFrames

# Função para mudar a skin (pode ser chamada de qualquer menu/loja)
func set_skin(skin_name: String) -> void:
	if skins.has(skin_name):
		current_skin = skin_name
