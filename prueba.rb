 
#clase para abrir el archivo.
#def initialize es el constructor
#def archivo devuelve la variable archivo
class Archivos
	attr_accessor :archivo
	def initialize(ruta)
		@archivo=File.open(ruta)
	end
	def archivo
		@archivo
	end
end
#metodo creado por mi solo detecta los errores de palabras reservadas.
=begin
#La condicion me sirve para ver si la cadena que entra es mayor a 1 si es mayo a 1 hace lo siguiente
#k=0 y declaro un array de booleanos
#El primer while me sirve para comparar si la cadena incluye alguna de las palabreas reservadas y si la variable k es menor al tamaño de la cadena
#si cumple entra al primer while.
#obtengo una cadena concatenandole una letra cada paso del ciclo si se cumple con la condicion del while
## ejemplo cadena "while" primera vez dentro del ciclo cadena1="w" segunda vez en el ciclo cadena1="wh" y asi sucesivamente
#hago i=0 para verificar el siguiente while, si i es menor al tamaño del vector palabra reservada hace lo siguiente
#hago j=0
#si la cadena que esta en estos momentos en cadena1 incluye alguna de las palabras reservadas
#hace la segunda posicion del array de booleanos a falso
#termina la condicion
#en el elsif verifico si en la segunda posicion del bandera es verdadera si es verdadera eso queiere decir que
la cadena puede tener un error digo puede porque falta se compara completamente
#si no inlcuye hace un while donde la pimera posicion de bandera sea verdadera si es verdadera se hace la comparacion correspondiente
#si la cadena poniendolo todo en minuscula es igual a la alguna de las palabras reservadas
#######ejemplo
cadena1="wHile" con downcase cadena1="while" y comparandolo en el vector nos regresa true
candea1.downcase.eql?palabraReservada[i] es igual a decir
"while"=="while"=true
#si es verdadero capturamos el numero de la linea, el token con error y la linea completa donde esta el error
#ponemos la primera posicion de bandera en false para parar el ciclo y ponemos la 3ra posicion bandera verdadero
esto para decirle que si lo encontro
#si no es igual pero j= al tamaño de la palabra reservada
#hacemos la 3ra posicion falso que no lo ha encontrado y bandera en la 1ra posicion para salir
#aumentamos j
#al salir del 3er while pregunta si la bandera en la posicion 2 es falso es decir si no lo encontro va a seguir comparando
pero para esto necesitamos que la pimera bandera este en true
#si lo encontro seguíra haciendo el proceso pero ya no entrando al 3er while ya no compararia las cadenas
#aumentamos i par ael segundo while
#termina el segundo while
#aunmentamos k para el primer while
#termina el primer while
#termina la condicion
#termina el metodo
=end
def CapturarErroresPR(cad, palabraReservada,index)	#recibe como parametro una cadena, un vector y el indice donde puede ocurrir o no el error
	
	if cad.length>1 							#si el tamaño de la cadena que recibe es mayor a 1 hace lo siguiente
		k=0
		bandera=[true,true,true]
		while k<cad.length	
			cadena1=cad[0,k+1]
			i=0
			while i<palabraReservada.length&&bandera[1]
				j=0
				if cadena1.include?(palabraReservada[i])
					bandera[1]=false
				elsif bandera[1]
					while bandera[0]
						if cadena1.downcase.eql?(palabraReservada[i])
							puts "Error en la linea #{index+1} token con error #{cadena1}"
							puts "Linea completa #{cad}"
							bandera[0]=false
							bandera[2]=true
						elsif j==palabraReservada.length
							bandera[2]=false
							bandera[0]=false
						end
						j+=1
					end
				end
				if !bandera[2]
					bandera[0]=true
				end
				i+=1
			end
			k+=1
		end
		bandera[2] ? 1:2
	end
end

def CapturarErrorOp(cad,operador,palabraReservada,index)
	cont=0
	cad.each_char do |c|
		if c!=operador
			cont+=1
		else
			break
		end
	end
	cad1=cad[(cont+1),cad.length]
	entero=cad1.to_i
	if cad1[0]=="=" || entero>0 || cad1[0]=="0" || entero<0
		1
	elsif entero==0 && cad1.length>0
		if (operador==">"|| operador=="<")
			CapturarErroresPR(cad1,palabraReservada,index)
			puts "Error en la linea #{index+1} en el operador #{operador} linea #{cad}"
		end
	end
end

#Declaro algunos vectores me sirven mas abajo	
palabraReservada=["int","float","bool","string","if","else","while","do","true","false"]
palabraReservadacont=[0,0,0,0,0,0,0,0,0,0]
operadores=["+","-","*","/","%","=","==","<",">",">=","<=","\!","\!="]
operadorescont=[0,0,0,0,0,0,0,0,0,0,0,0,0]
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
	cont=0
	if array.length!=1 && array.length!=0	##si el array su tamaño es diferente de 1 y de 0 hace lo siguiente
		array.each do |cad|					#each para iterar el array
			cad=cad.strip					#le quito los tabuladores con ese metodo
			cad.length>0 ? CapturarErroresPR(cad,palabraReservada,index) : 0		#llamo al metodo creado por mi le mando como parametro la cadena el array y la posicion de la linea
			signoscont[0]+=cad.count("(")					#estos métodos todos cuentan cuantos hay en cada linea
			signoscont[1]+=cad.count(")")
			signoscont[2]+=cad.count("{")
			signoscont[3]+=cad.count("}")
			signoscont[4]+=cad.count("\"")

			if cad.casecmp?"int"
				palabraReservadacont[0]+=1
			elsif cad.casecmp?"float"
				palabraReservadacont[1]+=1
			elsif cad.casecmp?"bool"
				palabraReservadacont[2]+=1
			elsif cad.casecmp?"string"
				palabraReservadacont[3]+=1
			elsif cad.casecmp?"if"
				palabraReservadacont[4]+=1
			elsif cad.casecmp?"else"
				palabraReservadacont[5]+=1
			elsif cad.casecmp?"while"
				palabraReservadacont[6]+=1
			elsif cad.casecmp?"do"
				palabraReservadacont[7]+=1
			elsif cad.casecmp?"true"
				palabraReservadacont[8]+=1
			elsif cad.casecmp?"false"
				palabraReservadacont[9]+=1
			
			elsif ((cad.include?"=") && (cad.include?("\!")))
				if cad.count("=")==1 && cad.count("\!")==1
					if CapturarErrorOp(cad,"\!",palabraReservada,index)==1
						operadorescont[12]+=1
					else
						puts "Error en la linea #{index+1} linea del error #{cad}"
					end
				else
					puts "Error en la linea #{index+1} linea del error #{cad}"
				end
			elsif ((cad.include?"=") && (cad.include?("<")))
				if cad.count("=")==1 && cad.count("<")==1
					if CapturarErrorOp(cad,"<",palabraReservada,index)==1
						operadorescont[10]+=1
					else
						puts "Error en la linea #{index+1} linea del error #{cad}"
					end
				else
					puts "Error en la linea #{index+1} linea del error #{cad}"
				end
			elsif ((cad.include?"=") && (cad.include?(">")))
				if cad.count("=")==1 && cad.count(">")==1
					if CapturarErrorOp(cad,">",palabraReservada,index)==1
						operadorescont[9]+=1
					else
						puts "Error en la linea #{index+1} linea del error #{cad}"
					end
				else
					puts "Error en la linea #{index+1} linea del error #{cad}"
				end
			elsif cad.count("==")==2
				if CapturarErrorOp(cad,"=",palabraReservada,index)==1
					operadorescont[6]+=1
				else
					puts "Error en la linea #{index+1} linea del error #{cad}"
				end
			elsif cad.count(">")==1
				CapturarErrorOp(cad,">",palabraReservada,index)==1 ? operadorescont[8]+=1 : 0
			elsif cad.count("<")==1
				CapturarErrorOp(cad,"<",palabraReservada,index)==1 ? operadorescont[7]+=1 : 0
			end
			# palabraReservadacont[4]+=cad.count("if")
			# palabraReservadacont[5]+=cad.count("else")
			# palabraReservadacont[6]+=cad.count("while")
			# palabraReservadacont[7]+=cad.count("do")
			# palabraReservadacont[8]+=cad.count("true")
			# palabraReservadacont[9]+=cad.count("false")
			operadorescont[0]+=cad.count("+")
			operadorescont[1]+=cad.count("-")
			operadorescont[2]+=cad.count("*")
			operadorescont[3]+=cad.count("/")
			operadorescont[4]+=cad.count("%")
			if cad.end_with?';'								#si la cadena termina con ";" los tomara todos
				signoscont[5]+=1
			end
		end 								#termina el if
	elsif array.length==1 					#de lo contrario si la cadena es 1 sola linea hago lo siguiente
			cad=array[0].strip 				#le vuelvo a quitar los tabuladores en este caso jalo del array =0 porque como es solo 1 vector
			cad.length>0 ? CapturarErroresPR(cad,palabraReservada,index) : 0  #vuelvo a llamar a mi método

			if cad.casecmp?"int"
				palabraReservadacont[0]+=1
			elsif cad.casecmp?"float"
				palabraReservadacont[1]+=1
			elsif cad.casecmp?"bool"
				palabraReservadacont[2]+=1
			elsif cad.casecmp?"string"
				palabraReservadacont[3]+=1
			elsif cad.casecmp?"if"
				palabraReservadacont[4]+=1
			elsif cad.casecmp?"else"
				palabraReservadacont[5]+=1
			elsif cad.casecmp?"while"
				palabraReservadacont[6]+=1
			elsif cad.casecmp?"do"
				palabraReservadacont[7]+=1
			elsif cad.casecmp?"true"
				palabraReservadacont[8]+=1
			elsif cad.casecmp?"false"
				palabraReservadacont[9]+=1
			end
			signoscont[0]+=cad.count("(")	#lo mismo cuento cuantos signos hay en esta linea
			signoscont[1]+=cad.count(")")
			signoscont[2]+=cad.count("{")
			signoscont[3]+=cad.count("}")
			signoscont[4]+=cad.count("\"")
			if ((cad.include?"=") && (cad.include?("\!")))
				if cad.count("=")==1 && cad.count("\!")==1
					if CapturarErrorOp(cad,"\!",palabraReservada,index)==1
						operadorescont[12]+=1
					else
						puts "Error en la linea #{index+1} linea del error #{cad}"
					end
				else
					puts "Error en la linea #{index+1} linea del error #{cad}"
				end
			elsif ((cad.include?"=") && (cad.include?("<")))
				if cad.count("=")==1 && cad.count("<")==1
					if CapturarErrorOp(cad,"<",palabraReservada,index)==1
						operadorescont[10]+=1
					else
						puts "Error en la linea #{index+1} linea del error #{cad}"
					end
				else
					puts "Error en la linea #{index+1} linea del error #{cad}"
				end
			elsif ((cad.include?"=") && (cad.include?(">")))
				if cad.count("=")==1 && cad.count(">")==1
					if CapturarErrorOp(cad,">",palabraReservada,index)==1
						operadorescont[9]+=1
					else
						puts "Error en la linea #{index+1} linea del error #{cad}"
					end
				else
					puts "Error en la linea #{index+1} linea del error #{cad}"
				end
			elsif cad.count("==")==2
				if CapturarErrorOp(cad,"=",palabraReservada,index)==1
					operadorescont[6]+=1
				else
					puts "Error en la linea #{index+1} linea del error #{cad}"
				end
			elsif cad.count(">")==1
				CapturarErrorOp(cad,">",palabraReservada,index)==1 ? operadorescont[8]+=1 : 0
			elsif cad.count("<")==1
				CapturarErrorOp(cad,"<",palabraReservada,index)==1 ? operadorescont[7]+=1 : 0
			end
			# palabraReservadacont[0]+=cad.count("int","^i","^n","^t")
			# palabraReservadacont[1]+=cad.count("float")
			# palabraReservadacont[2]+=cad.count("bool")
			# palabraReservadacont[3]+=cad.count("String")
			# palabraReservadacont[4]+=cad.count("if")
			# palabraReservadacont[5]+=cad.count("else")
			# palabraReservadacont[6]+=cad.count("while")
			# palabraReservadacont[7]+=cad.count("do")
			# palabraReservadacont[8]+=cad.count("true")
			# palabraReservadacont[9]+=cad.count("false")
			operadorescont[0]+=cad.count("+")
			operadorescont[1]+=cad.count("-")
			operadorescont[2]+=cad.count("*")
			operadorescont[3]+=cad.count("/")
			operadorescont[4]+=cad.count("%")
			if cad.end_with?';'
				signoscont[5]+=1
			end
	end
end
#muestro la cantidad de signos que se encontraron
for i in (0..palabraReservadacont.length-1)
	puts "Se encontraron #{palabraReservadacont[i]} veces la palabra reservada #{palabraReservada[i]}"
end
puts "---------------------------------------------------------"
for i in (0..signoscont.length-1)
	puts "Se encontraron #{signoscont[i]} veces el signo #{signos[i]}"
end
puts "---------------------------------------------------------"
for i in (0..operadorescont.length-1)
	puts "Se encontraron #{operadorescont[i]} veces el operador #{operadores[i]}"
end
# puts "---------------------------------------------------------"

