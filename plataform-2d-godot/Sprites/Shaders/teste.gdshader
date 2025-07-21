// Este shader simples desenha um círculo dentro do retângulo
shader_type canvas_item;

void fragment() {
    // Calcula a distância do pixel atual (UV) para o centro (0.5, 0.5)
    float distance_from_center = distance(UV, vec2(0.5));

    // Se a distância for maior que o raio (0.5), o pixel fica transparente
    if (distance_from_center > 0.5) {
        COLOR.a = 0.0; // Define o Alpha (transparência) para 0
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
