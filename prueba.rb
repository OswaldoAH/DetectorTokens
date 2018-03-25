class Archivos
	attr_accessor :archivo
	def initialize(ruta)
		@archivo=File.open(ruta)
	end
	def archivo
		@archivo
	end
end
#metodo creado por mi solo detecta los errores al principio.
=begin
#El primer while me sirve para comparar si la cadena incluye alguna de las palabreas reservadas y si la variable k es menor al tamaño de la cadena
si cumple entra al primer while.
#obrento una cadena concatenandole una letra cada paso del ciclo si no se cumple con la condicion
## ejempli cadena "while" primera vez dentro del ciclo cadena1="w" segunda vez en el ciclo cadena1="wh" y asi sucesivamente
#hago j=0 para verificar el siguiente while, si j es menor al tamaño del vector palabra reservcada hace lo siguiente
#si la cadena que esta tomando en cada paso del ciclo es igual a alguna de las palabras reservadas
muestra el mensaje de error en la linea y que cadena y hago k = al tamaño del vector para romper el ciclo
## Nota el metodo casecmp? compara un string con otro ejemplo "whiLE"(cadena obtenida) se compara con "while" y devuelve true
si es igual no importa que este escrito mal con tal que diga lo mismo es true
#termina el if
#aumento j 
#termina el segunto while
#aumento i
#si i = al tamaño del vector vuelvo a hacer i=0
#termina el if
#aumento k
#termina el primer while
#termina el bloque del if
#termina el bloque del metodo.
=end
def CapturarErrores(cad, palabraReservada,index)	#recibe como parametro una cadena, un vector y el indice donde puede ocurrir o no el error
	if cad.length>1 							#si el tamaño de la cadena que recibe es mayor a 1 hace lo siguiente
		i=0										#declaro 3 variables que me serviran en mis ciclos
		j=0
		k=0

		while (!cad.include?(palabraReservada[i])&&(k<cad.length))	
			cadena1=cad[0,k+1]
			j=0
			while j<palabraReservada.length
				if cadena1.casecmp?(palabraReservada[j])
					puts "Error en la linea #{index+1} #{cad}"
					k=palabraReservada.length
				end
				j+=1
			end
			i+=1
			if i==palabraReservada.length
				i=0
			end
			k+=1
		end
	end

end

#Declaro algunos vectores me sirven mas abajo	
palabraReservada=["int","float","bool","string","if","else","while","do","true","false"]
palabraReservadacont=Array.new(palabraReservada.length)
operadores=["+","-","*","/","%","=","==","<",">",">=","<="]
operadorescont=[0]
signos=["(",")","{","}","\"",";"]
signoscont=[0,0,0,0,0,0]
file=Archivos.new("prueba.txt") #instancio la clase
cont=0 #contador que me va a servir para mi array
arreglo=Array.new(1) #declaro el array no importa el tamaño

while linea=file.archivo.gets#mientras tenga lineas el txt va a hacer lo siguiente
	arreglo[cont]=linea.chomp #guardo en el array la linea y le quito el salto de linea
	cont+=1 #incremento cont
end#termina el while
arreglo.each_with_index do |array,index| #each para ir iterrar el vector que en este caso cada posicion del vector es una "linea del txt"
	array=array.split(/ /)				 #Sepraro cada linea si es que se puede en array detectando cada espacio 
	if array.length!=1 && array.length!=0	##si el array su tamaño es diferente de 1 y de 0 hace lo siguiente
		array.each do |cad|					#each para iterar el array
			cad=cad.strip					#le quito los tabuladores con ese metodo
			CapturarErrores(cad,palabraReservada,index)		#llamo al metodo creado por mi le mando como parametro la cadena el array y la posicion de la linea
			signoscont[0]+=cad.count("(")					#estos métodos todos cuentan cuantos hay en cada linea
			signoscont[1]+=cad.count(")")
			signoscont[2]+=cad.count("{")
			signoscont[3]+=cad.count("}")
			signoscont[4]+=cad.count("\"")
			if cad.end_with?';'								#si la cadena termina con ";" los tomara todos
				signoscont[5]+=1
			end
		end 								#termina el if
	elsif array.length==1 					#de lo contrario si la cadena es 1 sola linea hago lo siguiente
			cad=array[0].strip 				#le vuelvo a quitar los tabuladores en este caso jalo del array =0 porque como es solo 1 vector
			CapturarErrores(cad,palabraReservada,index)  #vuelvo a llamar a mi método
			signoscont[0]+=cad.count("(")	#lo mismo cuento cuantos signos hay en esta linea
			signoscont[1]+=cad.count(")")
			signoscont[2]+=cad.count("{")
			signoscont[3]+=cad.count("}")
			signoscont[4]+=cad.count("\"")
			if cad.end_with?';'
				signoscont[5]+=1
			end
	end
end
#muestro la cantidad de signos que se encontraron
for i in (0..signoscont.length-1)
	puts "Se encontraron #{signoscont[i]} veces el signo #{signos[i]}"
end

=begin
para detectar los errores que no estan al principio intentaré hacer despues del = comparar xd :V es similar
a como lo hice al principio solo necesitaria movermehasta el = solo eso faltaría amigo :D	
=end