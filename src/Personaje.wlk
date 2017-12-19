import Direccion.*
import RickAndMortyInit.*

	//Crear object personaje para el juego. Definir grafica segun eleccion del usuario. Ver
object personaje inherits PersonajeRecolector(3, rick){//Recolector en realidad
	var posicion = new Position(2, 2)//Falta decidir donde empieza Morty
	var direccion = new Abajo(self)			

		method getImagen() = "personaje1-" + direccion.sentido() + ".png"//Conseguir imagen de frente

		method getPosicion() = posicion
	
		method setPosicion(_posicion){ 
			posicion = _posicion 
		}
		
		method coordenadaX()  = posicion.getX()
	
		method coordenadaY()  = posicion.getY()
		
		method moverHaciaAbajo(){
			self.setDireccion(new Abajo(self))
			direccion.moverEnSentido()
		}	
			
		method moverHaciaArriba(){
			self.setDireccion(new Arriba(self))
			direccion.moverEnSentido()	
		}	
	
		method moverHaciaIzquierda(){
			self.setDireccion(new Izquierda(self))
			direccion.moverEnSentido()
		}
		
		method moverHaciaDerecha(){
			self.setDireccion(new Derecha(self)) 
			direccion.moverEnSentido()
		}

		method unPaso()  = 1
	
		method getDireccion() = direccion

		method setDireccion(_direccion){
			direccion = _direccion
		}
}	
	

