///////////////////////////////////////////////// Personajes /////////////////////////////////////////////////

object morty{
	const mochila = #{}
	var energia = 100 //Inicialmente, Morty empieza con 100 de energia. Esto puede variar.
		
		method recibir(unosObjetos){//No pedido para Morty, pero lo agregamos por comodidad a la hora de realizar el test.
			mochila.addAll(unosObjetos)
		}	
		
			//Dado un material, lo guarda en la mochila. 
		method meterEnLaMochila(unMaterial){
			mochila.add(unMaterial)	
		}
		
			//Dada una cantidad, disminuye la energia de Morty en dicho valor.
		method disminuirEnergia(unaCantidad){
			energia -= unaCantidad
		}
		
			//Dada una cantidad, aumenta la energia de Morty en dicho valor.
		method aumentarEnergia(unaCantidad){
			energia += unaCantidad
		}
		
			//Dado un material, retorna "True" en caso de que Morty pueda recolectar dicho material. Caso contrario retorna "False". 
		method puedeRecolectar(unMaterial) = self.tieneLugarenLaMochila() && self.tieneEnergiaParaLevantar(unMaterial)
		
			//Retorna "True" si Morty tiene lugar en su mochila. Es decir, menos de 3 materiales. Caso contrario, retorna "False".
		method tieneLugarenLaMochila() = mochila.size() < 3
		
			//Dado un material, retorna "True" si Morty tiene energia para recolectar dicho material.
		method tieneEnergiaParaLevantar(unMaterial) = energia >= unMaterial.cuantaEnergiaSeNecesitaParaRecolectarlo()
			
			//Dado un material, si Morty puede recogerlo, lo agrega a su mochila, caso contrario, tira un error avisando que no es posible realizar dicha accion. 
		method recolectar(unMaterial){
			if(!self.puedeRecolectar(unMaterial)){
				self.error("Morty no puede recolectar el material en este momento.")
			}
			//Dudas sobre esta parte. De quien es la responsabilidad?
			self.meterEnLaMochila(unMaterial)
			unMaterial.loQueVariaLaEnergiaCuandoLoRecoge(self) //No estoy seguro de esta parte
		}
		
			//Dado un companiero, agrega la mochila de Morty al inventario/mochila de dicho companiero. 
		method darObjetos(unCompaniero){
			unCompaniero.recibirObjetos(mochila) //El companiero de Morty debe entender este mensaje
			self.descartarObjetos()
		}
		
			//Vacia la mochila de Morty.
		method descartarObjetos(){
			mochila.removeAll()
		}
}


///////////////////////////////////////////////// Materiales /////////////////////////////////////////////////
 
class Material{
				
			method esRadioactivo() = false //A excepcion del Fleeb, los materiales no son radioactivos.
			
			method electricidadGenerada() = 0 
				
				//Segun enunciado la cantidad de energia necesaria para recolectar un material es igual a la cantidad de gramos de metal de dicho material.	
			method cuantaEnergiaSeNecesitaParaRecolectarlo() = self.cantMetal()
			
				//Dada un "alguien", disminuye la energia del mismo, en cuanto a la energia que se necesita para recoger al material.
			method loQueVariaLaEnergiaCuandoLoRecoge(alguien){
				alguien.disminuirEnergia(self.cuantaEnergiaSeNecesitaParaRecolectarlo())//Esta bien esta responsabilidad??
			}
			
			method cantMetal() //Abstracto - Si bien es la super clase Material el metodo es abstracto se espera que lo que devuelve esta expresado en grs. 
			
			method nivelDeConductividad() //Abstracto
			
}

class Lata inherits Material{
	const cantMetal 		
		
		constructor(unaCantidad){//Una cantidad expresada en gr.
			cantMetal = unaCantidad	
		}
													//Amperes
			override method nivelDeConductividad() = 0.1 * cantMetal 
}
	
class Cable inherits Material{
	const longitud
	const seccionTransversal
	
		constructor(unaLongitud, unaSeccion){
			longitud = unaLongitud
			seccionTransversal = unaSeccion			
		}
		
			override method cantMetal() = (longitud / 1000) * seccionTransversal  
								
																		//Amperes
			override method nivelDeConductividad() = seccionTransversal * 3
}

class Fleeb inherits Material{
	var edad = 0 //En un principio, el Fleeb no es radiactivo
	const materialesConsumidos = #{}
					
				//Retorna la edad de Fleeb
			method edad() = edad
			
				//No se pide, pero si habla de que la edad del Fleeb cambia, entonces hay que hacer una forma que la misma se pueda actuaalizar.
			method cumplirAnios(){
				edad += 1 
			}
				
				//Dado un material, lo agrega a la coleccion de materiales consumidos del Fleeb.
			method consumir(unMaterial){
				materialesConsumidos.add(unMaterial)
			}
			
				//Dada una coleccion de materiales.
			method consumirMateriales(unosMateriales){ //No pedido, se agrega por comodidad a la hora de realizar el test.
				materialesConsumidos.addAll(unosMateriales)
			}
			
				//Retorna la cantidad total de metal de todos los materiales consumidos por el Fleeb.
			override method cantMetal() = materialesConsumidos.sum { material => material.cantMetal() } 
			
				//Retorna la electricidad que genera el Fleeb, la cual es igual a la cantidad que produce el material que mas energia produce. El Fleeb debe de haber consumido por lo menos un material.
			override method electricidadGenerada() = self.elMaterialConsumidoQueMasElectricidadProduce().nivelDeConductividad()
			
				//Retorna el material consumido que mas electricidad produce.
			method elMaterialConsumidoQueMasElectricidadProduce() = materialesConsumidos.max { material => material.electricidadGenerada() } 
			
				//Denota el nivel de conductividad del Fleeb, el cual esta dado por el material consumido que menos conductividad posee.
			override method nivelDeConductividad() = self.elMaterialConsumidoQueMenosConduce().nivelDeConductividad()
			
				//Retorna el material consumido por el Fleeb que menos conductividad posee. 
			method elMaterialConsumidoQueMenosConduce() = materialesConsumidos.min { material => material.nivelDeConductividad() }
				
				//Retorna "True" si el Fleeb es radioactivo. Caso contrario, retorna "False". Se considera que un Fleeb es radioactivo si su edad es mayor a 15 años.
			override method esRadioactivo() = self.edad() > 15 //Tambien se podria escribir la variable y borrar el metodo.
			
				//Retorna la cantidad de energia que se necesita para recolectar a un Fleeb. Esta cantidad es el doble de lo que se necesita para recoger a cualquier otro material.
			override method cuantaEnergiaSeNecesitaParaRecolectarlo() = 2 * super() 
			
				//Dado un "alguien", si el Fleeb NO es radioactivo, aumenta la energia del individuo en 10 unidades. Caso contrario, actua como el resto de los materiales. 
			override method loQueVariaLaEnergiaCuandoLoRecoge(alguien){
				if(!self.esRadioactivo()){
					alguien.incrementarEnergia(10)
				}				
				else{
					super(alguien)//Esto es asi o deberia de no hacer nada?
				}
			}

}			

class MateriaOscura inherits Material{
	const materialBase //El enunciado no dice que esto pueda variar.
		
		constructor(unMaterial){
			materialBase = unMaterial	
		}
				//El nivel de conductividad de la Materia Oscura es igual que la materia base.
			override method nivelDeConductividad() = materialBase.nivelDeconductividad() / 2
			
				//La cantidad de metal de la materia oscura es igual a la cantidad de metal que posee su material base.
			override method cantMetal() = materialBase.cantMetal()
				
				//La electricidad generada de la materia oscura es el doble de la generada por su material base.
			override method electricidadGenerada() = materialBase.electricidadGenerada() * 2 
}

///////////////////////////////////////////////// Personajes /////////////////////////////////////////////////

object rick{
	var companiero = morty//Inicialmente decimos que el compañero de Rick es Morty, pero esto puede variar en el futuro.	
	const mochila = #{}
	
		method cambiarCompaniero(unCompaniero){
			companiero = unCompaniero
		} 
		method tieneMaterialQueCumpla(unaCondicion) = mochila.any { unaCondicion.apply() }
}

class Experimento{//Si voy a dejar os metodos abstractos la clase es innecesaria
	method cumpleRequerimientos(alguien)//Abstracto

	method loQueProduce()//Abstracto
	
}

class ConstruirBateria inherits Experimento{
	override method cumpleRequerimientos(alguien) = alguien.tieneMaterialQueCumpla({material => material.cantMetal() > 200}) 
}

class ConstruirCircuito inherits Experimento{
	
}

class ShockElectrico inherits Experimento{
	
}


