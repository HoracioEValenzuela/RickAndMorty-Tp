
///////////////////////////////////////////////// Materiales /////////////////////////////////////////////////
 
class Material{
				
		method esRadiactivo() = false //A excepcion del Fleeb, los materiales no son radioactivos.
		
		method electricidadGenerada() = 0 //Esto esta bien? 
			
			//Segun enunciado la cantidad de energia necesaria para recolectar un material es igual a la cantidad de gramos de metal de dicho material.	
		method cuantaEnergiaSeNecesitaParaRecolectarlo() = self.cantMetal()
		
			//Dada un "alguien", disminuye la energia del mismo, en cuanto a la energia que se necesita para recoger al material.
		method provocarEfecto(alguien){
			alguien.disminuirEnergia(self.cuantaEnergiaSeNecesitaParaRecolectarlo())
		}
		
		method generaElectricidad() = self.electricidadGenerada() > 0 //Esto esta bien? 
		
		method conduceElectricidad() = self.nivelDeConductividad() > 0 //Esto esta bien? 
		
		method cantMetal() //Abstracto - Si bien es la super clase Material el metodo es abstracto se espera que lo que devuelve esta expresado en grs. 
		
		method nivelDeConductividad() //Abstracto		
}

class Lata inherits Material{
	const cantMetal 		
		
		constructor(unaCantidad){//Una cantidad expresada en gr.
			cantMetal = unaCantidad	
		}
			
			override method cantMetal() = cantMetal
			
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
	var edad //En principio, hasta los 15, el Fleeb no es radiactivo
	const materialesConsumidos
				
			constructor(unaEdad, unosMateriales){
					edad = unaEdad
					materialesConsumidos = unosMateriales	
				}	
				
					//Retorna la edad de Fleeb
				method edad() = edad
				
					//Dado un material, lo agrega a la coleccion de materiales consumidos del Fleeb.
				method consumir(unMaterial){
					materialesConsumidos.add(unMaterial)
				}
				
					//Dada una coleccion de materiales.
				method consumirMateriales(unosMateriales){ //No pedido, se agrega por comodidad a la hora de realizar el test.
					materialesConsumidos.addAll(unosMateriales)
				}
				
				
					//Retorna el material consumido que mas electricidad produce.
				method elMaterialConsumidoQueMasElectricidadProduce() = materialesConsumidos.max { material => material.electricidadGenerada() } 
				
					
					//Retorna el material consumido por el Fleeb que menos conductividad posee. 
				method elMaterialConsumidoQueMenosConduce() = materialesConsumidos.min { material => material.nivelDeConductividad() }
				
				
					//Retorna la cantidad total de metal de todos los materiales consumidos por el Fleeb.
				override method cantMetal() = materialesConsumidos.sum { material => material.cantMetal() } 
				
				
					//Retorna la electricidad que genera el Fleeb, la cual es igual a la cantidad que produce el material que mas energia produce. El Fleeb debe de haber consumido por lo menos un material.
				override method electricidadGenerada() = self.elMaterialConsumidoQueMasElectricidadProduce().nivelDeConductividad()
				
				
					//Denota el nivel de conductividad del Fleeb, el cual esta dado por el material consumido que menos conductividad posee.
				override method nivelDeConductividad() = self.elMaterialConsumidoQueMenosConduce().nivelDeConductividad()
									
				override method esRadiactivo() = self.edad() > 15 
				
				override method cuantaEnergiaSeNecesitaParaRecolectarlo() = 2 * super() 
				
					//Dado un "alguien", si el Fleeb NO es radioactivo, aumenta la energia del individuo en 10 unidades. Caso contrario, actua como el resto de los materiales. 
				override method provocarEfecto(alguien){
					if(! self.esRadiactivo()){
						alguien.incrementarEnergia(10)
					}				
					super(alguien)//Esto me hace ruido todavia. A su vez, entendemos que todo material cansa a quien lo recoge.
				}
}			

class MateriaOscura inherits Material{
	const materialBase//El enunciado no dice que esto pueda variar.
		
		constructor(unMaterial){
			materialBase = unMaterial	
		}
				//El nivel de conductividad de la Materia Oscura es igual que la materia base.
			override method nivelDeConductividad() = materialBase.nivelDeConductividad() / 2
			
				//La cantidad de metal de la materia oscura es igual a la cantidad de metal que posee su material base.
			override method cantMetal() = materialBase.cantMetal()
				
				//La electricidad generada de la materia oscura es el doble de la generada por su material base.
			override method electricidadGenerada() = materialBase.electricidadGenerada() * 2 

			override method esRadiactivo() = materialBase.esRadiactivo()
}


///////////////////////////////////////////////// MATERIALES COMPLEJOS /////////////////////////////////////////////////

class MaterialCompuesto inherits Material{
	var componentes
		
		constructor(unosComponentes){
			componentes = unosComponentes
		}
		
			method componentes() = componentes 
					
			override method cantMetal() = componentes.sum { componente => componente.cantMetal() }
}

class Bateria inherits MaterialCompuesto{
		
		override method nivelDeConductividad() = 0
		
		override method electricidadGenerada() = 2 * self.cantMetal()
		
		override method esRadiactivo() = true
		
		override method provocarEfecto(alguien){
			alguien.disminuirEnergia(5)
		}
}

class Circuito inherits MaterialCompuesto{
	
	method loQueConducenSusComponentes() = componentes.sum{ componente => componente.nivelDeConductividad() }
	
	override method nivelDeConductividad() = self.loQueConducenSusComponentes() * 3
	
	override method esRadiactivo() = componentes.any { componente => componente.esRadiactivo() }
	
	override method generaElectricidad() = false //Ver si es necesario, dado que material no modifica la cantidad de electricidad generada y en esa clase se detemrina que un material genera electricidad si su self.electricidadGenerada() > 0

	override method provocarEfecto(alguien){
		//No provoca nada.
	}
}

///////////////////////////////////////////////// EXPERIMENTOS /////////////////////////////////////////////////

	// -Aclaracion: A partir de aca, en lo que experimentos se refiere, cada vez que hablamos de "unaMochila",
	//				en realidad se refiere es a una coleccion de materiales. Hablamos de "mochila" a razon de conservar el dominio,
	//				y de seguir siendo descriptivos con los terminos que veniamos manejando antes.
	//					(*)  


class Experimento{//Si voy a dejar los metodos abstractos la clase es innecesaria
	const materialesNecesarios = #{}
	
			//Retorna la coleccion de materiales que necesita un eperimento para ser realizado.
		method materialesNecesarios() = materialesNecesarios
	
			//Dada una mochila* y una condicion, agrega a la coleccion de materiales necesarios un objeto de la mochila que cumpla dicha condicion.
		method materialesNecesarios(unaMochila, unaCondicion){
			materialesNecesarios.add(unaMochila.find(unaCondicion))
		}		
		
			//Dada una persona, le saca a la misma los materiales que necesita el experimento.
		method sacarleA(alguien){
			alguien.sacarEstos(self.materialesNecesarios())
		}
		
		method loQueProvoca(alguien){
			self.sacarleA(alguien)
			alguien.meterEnLaMochila(self.loQueProduce())//VER ESTO EN EL SHOCK ELECTRICO // Si llega a este punto no hace falta preguntar si tiene espacio o no en la mochila pues obvio que lo tiene
		}
		
		method hayMaterialesQueCumplan(unaMochila, unaCondicion) = unaMochila.any(unaCondicion)

		method tieneMaterialesNecesarios(unaMochila)//Abstracto
		
		method loQueProduce()//Abstracto

		method agarrarLoQueNecesita(unMochila)//Abstracto
}


object construirBateria inherits Experimento{
	const condicionDeRadiactivo = { material => material.esRadiactivo() }
	const condicionDeMetal = { material => material.cantMetal() > 200 }	
		
		method hayMaterialesRadiactivos(unaMochila) = self.hayMaterialesQueCumplan(unaMochila, condicionDeRadiactivo)	
		
		method hayMaterialesConMuchoMetal(unaMochila) = self.hayMaterialesQueCumplan(unaMochila, condicionDeMetal)
					
		override method agarrarLoQueNecesita(unaMochila){
			self.materialesNecesarios(unaMochila, condicionDeRadiactivo)
			self.materialesNecesarios(unaMochila, condicionDeMetal)
		}
		
			//Dada una mochila*, retorna "True" si en la misma hay materiales que sean radioactivos y hay materiales que tengan mas de 200 grs. de metal.
		override method tieneMaterialesNecesarios(unaMochila) = self.hayMaterialesRadiactivos(unaMochila) and  self.hayMaterialesConMuchoMetal(unaMochila)
		
			//Retorna una bateria cuyos componentes son los materiales necesarios del experimento.
		override method loQueProduce() = new Bateria(self.materialesNecesarios())
}        

object construirCircuito inherits Experimento{
	const condicionDeConductividad = { material => material.nivelDeConductividad() > 5 }
	
			//Dada una mochila*, retorna el conjunto de materiales de la misma que tenga una conductividad mator a 5 amperes.
		method losMaterialesConductores(unaMochila) = unaMochila.filter(condicionDeConductividad).asSet()
		
			//Dada una lista de materiales, agrega al conjunto de materiales necesarios, dichos materiales.
		method agregarTodos(unosMateriales){
			materialesNecesarios.addAll(unosMateriales)
		}
		
		override method agarrarLoQueNecesita(unaMochila){
			self.agregarTodos(self.losMaterialesConductores(unaMochila))
		}	
		
		override method tieneMaterialesNecesarios(unaMochila)= self.hayMaterialesQueCumplan(unaMochila, condicionDeConductividad)

			//Retorna un circuito cuyos componenetes son los materiales necesarios del experimento.
		override method loQueProduce() = new Circuito(self.materialesNecesarios())
}

object shockElectrico inherits Experimento{
	const condicionDeGenerarElectricidad = { material => material.generaElectricidad() }
	const condicionDeConducirElectricidad = { material => material.conduceElectricidad() }		
	
		method tieneMaterialQueGenereElectricidad(unaMochila) = self.hayMaterialesQueCumplan(unaMochila, condicionDeGenerarElectricidad)
	
		method tieneMaterialQueConduzcaElectricidad(unaMochila) = self.hayMaterialesQueCumplan(unaMochila, condicionDeConducirElectricidad)
		
		method elGenerador() = materialesNecesarios.max { materiales => materiales.electricidadGenerada() }
		
		method elConductor() = materialesNecesarios.max { materiales => materiales.nivelDeConductividad() } 
		
		method capacidadConductor() = self.elConductor().nivelDeConductividad()
		
		method capacidadGenerador() = self.elGenerador().electricidadGenerada()
		
		method provocarEfecto(alguien){
			alguien.incrementarEnergia(self.capacidadGenerador() * self.capacidadConductor())
		}
				
		override method tieneMaterialesNecesarios(unaMochila)= self.tieneMaterialQueGenereElectricidad(unaMochila) and self.tieneMaterialQueConduzcaElectricidad(unaMochila) 
			
		override method loQueProduce() = self
			//No produce ningun material como el resto de los experimentos.
		
		
		override method agarrarLoQueNecesita(unaMochila){
			self.materialesNecesarios(unaMochila, condicionDeGenerarElectricidad)
			self.materialesNecesarios(unaMochila, condicionDeConducirElectricidad)
		} 
		
		override method loQueProvoca(alguien){
			self.sacarleA(alguien)
		}
}

 ///////////////////////////////////////////////// Mochilas /////////////////////////////////////////////////

class Mochila{
	const objetos = #{} //Seria const, pero el hecho de vaciar se me facilita que sea var.
		
		method agregar(objeto){
			objetos.add(objeto)
		}
		
		method agregarEstos(unosObjetos){//Puede ser que la lista de objetos
			objetos.addAll(unosObjetos)
		}
		
		method sacar(unObjeto){
			objetos.remove(unObjeto)
		}
		
		method sacarEstos(unosObjetos){
			objetos.removeAll(unosObjetos)
		}
		
		method vaciar(){
			objetos.clear()
		}
		
		method tieneEspacioParaRecibir(materiales) = true
		
		method cuantosObjetosTiene() = objetos.size()
		
		method objetos() = objetos		
}

 class MochilaConLimite inherits Mochila{
	var limite 
		
		constructor(unLimite){
			limite = unLimite
		}	
		
			method tieneLugar() = self.espacioDisponible() > 0
		
			method laMedidaDe(materiales) = materiales.size()
	 
			method espacioDisponible() =  limite - self.cuantosObjetosTiene()  						
			
			method errorDeEspacio(){
				self.error("No hay suficiente espacio")
			} 
			
			override method agregarEstos(materiales){
				if(!self.tieneEspacioParaRecibir(materiales)){
					self.errorDeEspacio()
				}  
				super(materiales)
			}
			
			override method agregar(material){
				if(!self.tieneLugar()){
					self.errorDeEspacio()		
				}
				super(material)
			}
			
			override method tieneEspacioParaRecibir(materiales)  = self.laMedidaDe(materiales) <= self.espacioDisponible()
}


///////////////////////////////////////////////// Personajes /////////////////////////////////////////////////

class Personaje{//Clase creada por comodidad para juntar el comportamiento en comun de Rick y de Morty.
	const mochila
			
		constructor(unaMochila){
			mochila = unaMochila
		}
					
				//Dado una coleccion de objetos, los guarda en la mochila. No pedido, agregado por comodidad a la hora de hacer el test.
			method recibirObjetos(unosMateriales){
				mochila.agregarEstos(unosMateriales)
			}	
			
			
				//Dado un material, lo guarda en la mochila. 
			method meterEnLaMochila(unMaterial){
				mochila.agregar(unMaterial)	
			}
		
			method mochila() = mochila.objetos()
		
			method darObjetos(unCompaniero){
				if(!unCompaniero.puedeRecibir(self.mochila())){
					self.error("La mochila no tiene mas espacio suficiente")
				}
				else 
					unCompaniero.recibirObjetos(self.mochila()) //El companiero de Morty debe entender este mensaje*
					self.descartarObjetos()
			}
			
			method puedeRecibir(materiales) = mochila.tieneEspacioParaRecibir(materiales)
			
				//Dado un material, elimina de dicho material de la mochila del personaje.
			method sacar(unMaterial){
				mochila.sacar(unMaterial)
			}
		
				//Vacia totalmente la mochila del personaje.
			method descartarObjetos(){
				mochila.vaciar()
			}
						
				//Dada una lista de materiales, los saca de la moochila del personaje.
			method sacarEstos(unosMateriales){
				mochila.sacarEstos(unosMateriales)
			}
				
			//Dada una coleccion de objetos, y un companiero, saca de la mochila, esos objetos y los deposita en la mochila de dicho companiero. Tales objetos deben estar en la mochila del personaje.
			method darAlgunosObjetos(unosObjetos, unCompaniero){
				mochila.sacarEstos(unosObjetos)
				unCompaniero.recibir(unosObjetos)
			}
}

class PersonajeCompaniero inherits Personaje{
	var energia 
	
	constructor(unaCapacidadMaima, unaEnergia) = super(new MochilaConLimite(unaCapacidadMaima)){
		energia = unaEnergia
	}
		
		
		// (*1) setter de la energia por si en alguna ocasion se quiere empezar con otro valor
		method energia(unaEnergia){ 
					energia = unaEnergia//No pedido por el enunciado
		}
		
		method energia() = energia
		
		method disminuirEnergia(unaCantidad){
			energia = (energia  - unaCantidad).max(0)
		}
		
		method incrementarEnergia(unaCantidad){
			energia += unaCantidad 
		}
}

class PersonajeCreador inherits Personaje{
	var companiero
	const experimentos		
	
		constructor(unCompaniero, unosExperimentos) = super(new Mochila()){
			companiero = unCompaniero
			experimentos = unosExperimentos
		}
			
				//Retorna el companiero del personaje. En principio, este sera Morty para Rick, pero puede cambiar en el futuro.
			method companiero() = companiero
		
				//Dado un companiero, asigna el mismo como companiero del personaje. 
			method cambiarCompaniero(unCompaniero){
				companiero = unCompaniero
			}	
			
				//Dado un experimento, agrega el mismo a la coleccion del personaje. No pedido, pero se agrega para hacer el programa mas escalable, si se agregan experimentos en el futuro.
			method agregarExperimento(unExperimento){
				experimentos.add(unExperimento)//
			}
}


///////////////////////////////////////////////// Rick & Morty /////////////////////////////////////////////////
										
										//Limite mochila - energia respectivamente
object morty inherits PersonajeCompaniero(3, 100){
	//Inicialmente, Morty empieza con 100 de energia. Esto podria llegar a variar.(*1)
 
			//Dado un material, retorna "True" si Morty tiene energia para recolectar dicho material.
		method tieneEnergiaParaLevantar(unMaterial) = energia >= unMaterial.cuantaEnergiaSeNecesitaParaRecolectarlo()
			
			//Dado un material, si Morty puede recogerlo, lo agrega a su mochila, caso contrario, tira un error avisando que no es posible realizar dicha accion. 
		method recolectar(unMaterial){
			if(! self.puedeRecolectar(unMaterial)){
				self.error("Morty no puede recolectar el material en este momento.")
			}
			//Dudas sobre esta parte. De quien es la responsabilidad?
			self.meterEnLaMochila(unMaterial)
			unMaterial.provocarEfecto(self) //No estoy seguro de esta parte
		}
		method tieneLugarEnLamochila() = mochila.tieneLugar()		
				
			//Dado un material, retorna "True" en caso de que Morty pueda recolectar dicho material. Caso contrario retorna "False". 
		method puedeRecolectar(unMaterial) = self.tieneLugarEnLamochila() && self.tieneEnergiaParaLevantar(unMaterial)
}

object rick inherits PersonajeCreador(morty, #{construirBateria, construirCircuito, shockElectrico}){
	//Inicialmente decimos que el companiero de Rick es Morty, pero esto puede variar en el futuro.
	//Lo mismo decimos que los experimentos que saber hacer rick es el construoir la bateria, el circuito y el shock electrico, pero esta tmb puede cambiar.	
												 
		method experimentosQuePuedeRealizar() = experimentos.filter { experimento => experimento.tieneMaterialesNecesarios(self.mochila()) }
		
		method sePuedeRealizar(unExperimento) = unExperimento.tieneMaterialesNecesarios(self.mochila())
			
		method realizar(unExperimento){
			if(! self.sePuedeRealizar(unExperimento)){
				self.error("Rick no puede hacer el experimento en este instante.")
			}
			unExperimento.agarrarLoQueNecesita(self.mochila())//Es decir, copia los materiales que necesita de la mochila en la coleccion de materiales necesarios para el experimento
			unExperimento.loQueProvoca(self)
			unExperimento.loQueProduce().provocarEfecto(self.companiero())
		}
}