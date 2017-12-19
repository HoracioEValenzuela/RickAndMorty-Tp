class Individuo{
	var posicion
	var imagen
		
		constructor(_posicion, _imagen){//PersonajeDeJuego tambien le interesa este comportamiento?
			posicion = _posicion
			imagen = _imagen
			posicion.drawElement(_imagen)
		}
			
			//Asumo que es asi para averiguar las coordenadas x/y de una posicion dada
			method suCoordenadaX() = posicion.getX()
			
			method suCoordenadaY() = posicion.gety()

			method getPosicion() = posicion
	
			method setPosicion(_posicion){
				posicion = _posicion
			}
			
			method imagen() = imagen
}