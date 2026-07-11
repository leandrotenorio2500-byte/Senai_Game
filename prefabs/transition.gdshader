shader_type canvas_item;

uniform float screen_width = 1920.0;
uniform float screen_height = 1080.0;
uniform vec2 center = vec2(0.5);
uniform vec2 player = vec2(0.5);

uniform float progress : hint_range(0.0, 1.0);
uniform float pixel_size = 15.0;
uniform float circle_size : hint_range(0.0, 2.0) = 1.5;
uniform float curtains : hint_range(0.0, 1.0) = 1.0;

uniform int type : hint_range(0, 4) = 0;

void fragment() {
	// Proporção da tela para corrigir círculos ovais
	float ratio = screen_width / screen_height;

	// Tipo Diamante Pixel
	if (type == 0) {
		float xFraction = fract(FRAGCOORD.x / pixel_size);
		float yFraction = fract(FRAGCOORD.y / pixel_size);
		
		float xDistance = abs(xFraction - 0.5);
		float yDistance = abs(yFraction - 0.5);

		if (xDistance + yDistance + UV.x + UV.y > progress * 4.0) {
			discard;
		}
	}
	// Tipo Círculo no player
	else if (type == 1) {
		// Corrige a distorção esticando o eixo X baseado na proporção da tela
		vec2 uv_corrigido = vec2(UV.x * ratio, UV.y);
		vec2 player_corrigido = vec2(player.x * ratio, player.y);
		
		if (distance(player_corrigido, uv_corrigido) < circle_size * (1.0 - progress)) {
			COLOR.a = 0.0;
		}
	}
	// Tipo Círculo no Centro
	else if (type == 2) {
		// Corrige a distorção esticando o eixo X baseado na proporção da tela
		vec2 uv_corrigido = vec2(UV.x * ratio, UV.y);
		vec2 centro_corrigido = vec2(center.x * ratio, center.y);
		
		if (distance(centro_corrigido, uv_corrigido) < circle_size * (1.0 - progress)) {
			COLOR.a = 0.0;
		}
	}
	// Tipo Corte Vertical (Cortinas abrindo para os lados)
	else if (type == 3) {
		float dist_centro_x = abs(UV.x - 0.5);
		if (dist_centro_x < curtains * (1.0 - progress)) {
			COLOR.a = 0.0;
		}
	}
	// Tipo Corte Horizontal (Cortinas abrindo para cima/baixo)
	else if (type == 4) {
		float dist_centro_y = abs(UV.y - 0.5);
		if (dist_centro_y < curtains * (1.0 - progress)) {
			COLOR.a = 0.0;
		}
	}
}
