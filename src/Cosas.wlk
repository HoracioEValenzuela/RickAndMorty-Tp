import Personaje.*

class Cosa {
	var posicion
	var imagen
	
		constructor(_posicion, _imagen){
			posicion = _posicion
			imagen = _imagen
			_posicion.drawElement(self)
			game.whenCollideDo(self, {personaje => self.accion(personaje)} )
		}
		
			method accion(personaje){
				self.empujar(personaje)
			}
			
			method getPosicion() = posicion
	
			method setPosicion(_posicion){ 
				posicion = _posicion 
			}
	
			method imagen() = imagen
			
			method setImagen(_imagen2){
				imagen = _imagen2 
			}

			method sacarImagen(){
				imagen = null
			}

			method empujar(personaje) //Abstracto
		
}

/*
class CosaConAccionSeteable inherits CosaDireccional{
	const accion 
		constructor(_accion, _posicion, _imagen) = super( _posicion, _imagen){
			accion = _accion
		}	
			method accion() = accion
}
 */
 
 
class CosaQueDania inherits Cosa{
	const danio
	
		constructor(n, _posicion, _imagen) = super(_posicion, _imagen){
			danio = n
		}
		
			override method accion(_personaje){
				self.hacerDanio(_personaje)
			}
			
			method hacerDanio(_personaje){
				_personaje.disminuirEnergia(danio)
			}
		
} 

class Obstaculo inherits Cosa{
	
	override method empujar(personaje){
		personaje.getDireccion().moverAlOpuesto() 
		game.say(personaje, self.mensaje())
	}
	
	method mensaje() = "Todavia no puedo cruzar la materia... Todavia."

}

class CosaDireccional inherits Cosa{
	
	method valorEnDireccion() = return if(self.empujaDireccionContraria()) -1 else 1

	method empujaDireccionContraria() = false
}

/*
class CosaDireccionalContraria inherits CosaDireccional{
	override method empujaDireccionContraria() = true	//Revisar logica, genera un hueco en la gerencia, tal cual esta planteada.
}
 */

class CosaArribaOAbajo inherits CosaDireccional{
	
		override method empujar(_personaje) {
			_personaje.getPosicion().moveUp(self.valorEnDireccion())
		}

}

class CosaArriba inherits CosaArribaOAbajo{
	override method empujaDireccionContraria() = true
}


class CosaAbajo inherits CosaArribaOAbajo {
	
}


class CosaIzquierdaODerecha inherits CosaDireccional {
	
	override method empujar(personaje) {
		personaje.moveRight(self.valorEnDireccion())
	}
}

class CosaDerecha inherits CosaIzquierdaODerecha{
	 override method empujaDireccionContraria() = true
}

class CosaIzquierda inherits CosaIzquierdaODerecha{
	
}

