import Cosas.*
import Personaje.*
import Individuo.*

class EnemigoSimple inherits Individuo{ //Los enemigos simples se mueven similarmente a un caballo en un tablero de ajedrez: una casilla horizontal y una vertical. Como "l" inconclusa.
	const danio

		constructor(_posicion, _imagen, _danio) = super(_posicion, _imagen){
			danio = _danio
		}
		
			method atacar(personaje){
				personaje.disminuirEnegia(self.puntosDeAtaque())
			} 
			
			method puntosDeAtaque() = danio
			
			method perseguir(personaje){
				self.moverMejorPosicion(personaje)		
			}
			
			method moverMejorPosicion(personaje){
				self.moverMejorPosicionHorizontalConRespectoA(personaje)
				self.moverMejorPosicionVerticalConRespectoA(personaje)				
			}
			
			method moverMejorPosicionHorizontalConRespectoA(personaje){
				self.getPosicion().moveLeft(self.determinarSiParaIzquierdaODerecha())
			}
			
			method moverMejorPosicionVerticalConRespectoA(personaje){
					self.getPosicion().moveDown(self.determinarSiPAraArribaOParaAbajo())
				}
				
				
			method determinarSiPAraArribaOParaAbajo() = self.determinarSi(self.suCoordenadaY(), personaje.coordenadaY())   
			
			method determinarSiParaIzquierdaODerecha() = self.determinarSi(self.suCoordenadaX(), personaje.coordenadaX())
			
			method determinarSi(n1, n2) = return if(n1 > n2) self.uno() else if(n1 < n2) -(self.uno()) else 0

			method uno() = 1
}

class EnemigoPoderoso inherits EnemigoSimple{
	
}