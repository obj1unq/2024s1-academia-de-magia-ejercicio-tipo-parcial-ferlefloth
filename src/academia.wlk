// ver cuando es un atributo y cuando puede se algo que se calcula.
// se puede arrancar por los tests
// Cuando se hacen acciónes es necesario hacer validaciónes

/*class Marca{
	method utilidad()
}*/


//  Marcas
object cuchuflito{
	method utilidad(cosa){
		return 0 
	}
}
object acme{
	method utilidad(cosa){
		return cosa.volumen() / 2
	}
}
object fenix{
	method utilidad(cosa){
		return if(cosa.reliquia()) 3 else 0
	}
}







class CosaGuardable{
	var property marca
	var property volumen
	var property reliquia
	var property magico
	
	method utilidad(){
		return self.volumen() + self.utilidadSiMagica() + self.utilidadSiReliquia() + self.utilidadPorMarca()
	}
	
	method utilidadSiMagica(){
		return if (magico )3 else 0
	}
	
	method utilidadSiReliquia(){
		return if (reliquia) 5 else 0 
	}
	
	method utilidadPorMarca(){
		return marca.utilidad()
	}
	
	
}


class Mueble{
	const cosas = #{}
	
	method tiene(cosa){
		return cosas.contains(cosa)
	}
	
	method puedeGuardar(cosa){
		return not self.tiene(cosa)
	}
	
	method validarGuardar(cosa){
		if(not self.puedeGuardar(cosa)){
			self.error('No se puede guardar : ' + cosa)
		}
	}
	method guardar(cosa){
		self.validarGuardar(cosa)
		cosas.add(cosa)
	}
	
	method utilidad(){
		return self.utilidadDeLasCosas() / self.precio()
	}
	
	method utilidadDeLasCosas(){
		return cosas.sum({cosa => cosa.utilidad()})	
	}
	
	method precio()
	
	
}

class GabineteMagico inherits Mueble{
	const precio
	
	override method puedeGuardar(cosa){
		return super(cosa) and cosa.magico()
	}	
	
	override method precio(){
		return precio
	}
}

class Baul inherits Mueble{
	const property volumenMaximo
	
	override method puedeGuardar(cosa){
		return super(cosa) and self.hayEspacio(cosa)
	}
	
	method hayEspacio(cosa){
		return volumenMaximo >= self.volumenActual() + cosa.volumen()
	}
	
	method volumenActual(){
		return cosas.sum({cosa => cosa.volumen()})
	}
	
	override method precio(){
		return volumenMaximo + 2
	}
	
	override method utilidad(){
		return super() + self.extra() // NO DUPLICAR CODIGO! 
	}
	
	method extra(){
		return if(self.todasReliquias()) 2 else 0
	}
	
	method todasReliquias(){
		return cosas.all({cosa => cosa.reliquia()})
	}
}

class BaulMagico inherits Baul{
	
	override method extra(){
		return super() + self.cantidadDeMagicos()
	}
	
	
	method cantidadDeMagicos(){
		// filter + size = count
		// filter + anyOne = find
		// mapFlat = map + flatten	
		// max(bloque) = map + max (es parecido)
		
		return cosas.count({cosa => cosa.magico()})
	}
	
	override method precio(){
		return super() * 2
	}
}





class Armario inherits Mueble{
	const property cantidadMaxima

	override method puedeGuardar(cosa){
		return super(cosa) and self.hayLugar() 
	}	
	
	method hayLugar(){
		return cantidadMaxima > cosas.size() // Las cosas son PROPRIAS de de cada Mueble.
	}
	
	override method precio(){
		return 5 * cantidadMaxima
	}
	
	method remover(cosa){
		cosas.remove(cosa)
	}
}

class Academia{
	var property muebles = #{}
	
	method tiene(cosa){
		return muebles.any({mueble => mueble.tiene(cosa)})
	}
	
	method dondeGuarda(cosa){
		return muebles.find({mueble => mueble.tiene(cosa)})
	}
	
	method dondeGuardar(cosa){
		return muebles.filter({mueble => mueble.puedeGuardar(cosa)})
	}
	method existeMuebleParaGuardar(cosa){
		return muebles.any({mueble => mueble.puedeGuardar(cosa)})
	}
	method puedeGuardar(cosa){
		return not self.tiene(cosa) and self.existeMuebleParaGuardar(cosa)
	}
	
	method validarGuardarCosa(cosa){
		if(not self.puedeGuardar(cosa)){
			self.error("no se puede guardar la cosa: " + cosa)
		}
	}
	
	method elgirMueble(cosa){
		return self.dondeGuardar(cosa).anyOne()
	}
	
	method guardar(cosa){
		self.validarGuardarCosa(cosa)
		self.elgirMueble(cosa).guardard(cosa)
	}
	
	method menosUtiles(){
		return muebles.map({mueble=> mueble.menosUtil()}).asSet()
	}
	
	method marcaCosaMenosUtil(){
		return self.elMenosUtil().marca()
	}
	
	method elMenosUtil(){
			return self.menosUtiles().min({cosa => cosa.utilidad()})
	}
	
	method validarRemoverUtilesNoMagicas(){
		if(self.muebles().size() < 3){
			self.error('No hay muebles suficientes')
		}
	}
	
	method remover(cosa){
		self.dondeGuarda(cosa).remover(cosa)
	}
	method cosasMenosUtilesNoMagicas(){
		return self.menosUtiles().filter({cosa => !cosa.magico()})
	}
	method removerMenosUtilesNoMagicas(){
		self.validarRemoverUtilesNoMagicas()
		self.cosasMenosUtilesNoMagicas().forEach({
			cosa => self.remover(cosa)
		})
	}
}