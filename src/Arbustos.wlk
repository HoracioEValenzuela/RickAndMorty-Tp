import Cosas.*

class Arbusto inherits Obstaculo{
	
	constructor(_posicion) = super(_posicion, "arbusto.png")
	
		override method empujar(personaje){
			super(personaje)
			personaje.disminuirEnergia(self.danio())//Por simplicidad, decimos que todo arbusto causa 1 punto de danio a la energia del personaje.
		}
				
		override method mensaje() = "Puedo atravesar este arbusto, pero va a doler..." //Preguntar que quiere hacer el usuario? 
	
		method danio() = 1
		
		method dobleDanio() = self.danio() * 2
}