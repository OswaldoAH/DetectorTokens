 
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
	
	if ((cad.length>1) && !(cad.eql?"return"))				#si el tamaño de la cadena que recibe es mayor a 1 hace lo siguiente
		k=0
		bandera=[true,true,false]
		while k<cad.length
			cadena1=cad[0,k+1]
			i=0
			while i<palabraReservada.length&&bandera[1]
				j=0
				
				if cadena1.include?(palabraReservada[i])
					
					if cad.length>palabraReservada[i].length
						if !((cadena1.eql?"while") || (cadena1.eql?"if")||(cadena1.eql?"do"))
							if cadena1.eql?(palabraReservada[i])
								puts "1 Error en la linea #{index+1} token con error #{palabraReservada[i]}"
								puts "Linea completa #{cad}"
								return true
							else
								cont=0
								if !cad.eql?"false"
									palabraReservada[i].each_char { |c| cadena1.include?(c) ? cont+=1 :0 }
									if cont==palabraReservada[i].length
										puts "2 Error en la linea #{index+1} token con error #{palabraReservada[i]}"
										puts "Linea completa #{cad}"
										return true
									end
								end
							end
						else

							cadena2=cad[cadena1.length,cad.length]
							if !(((cadena1.eql?"while") || (cadena1.eql?"if"))&&(cadena2[0].eql?"("))
								if !((cadena1.eql?"do")&&(cadena2[0].eql?"{"))
									puts "3 Error en la linea #{index+1} token con error #{palabraReservada[i]}"
									puts "Linea completa #{cad}"
									return true
								else
									bandera[1]=false
								end
							else
								bandera[1]=false
							end
						end
					else
						bandera[1]=false
					end
				else
					
					if (cadena1==cad) && !(cad.eql?"false")
						# cadena1=cadena1.squeeze
						# cadena1.casecmp?("bol") ? cadena1="bool" : 0
						# palabraReservada.each_with_index  {|array,ind| cadena1.eql?(array) ? i=ind : 0}
						if cadena1.casecmp?(palabraReservada[i]) && !bandera[2]
							cadena1=cadena1.downcase
							bandera[2]=true
						end

						cont=0	
						palabraReservada[i].each_char { |c| cadena1.include?(c) ? cont+=1 :0 }
						
						if cont==palabraReservada[i].length
							puts "4 Error en la linea #{index+1} token con error #{palabraReservada[i]}"
							puts "Linea completa #{cad}"
							return true
						end
					else
						cadena1=cadena1.squeeze
						bandera[0]=false
					end
				end
				if bandera[1] && bandera[0]
					bandera[0]=true
					while bandera[0]
						if cadena1.downcase.eql?(palabraReservada[i])
							puts "5 Error en la linea #{index+1} token con error #{palabraReservada[i]}"
							puts "Linea completa #{cad}"
							bandera[0]=false
							return true
						elsif j==palabraReservada.length
							bandera[0]=false
						end
						j+=1
					end
				end
				i+=1
			end
			k+=1
		end
		return false
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
		true
	elsif cad1[0]=="t" || cad1[0]=="f" || cad1[0]=="T" || cad1[0]=="F"
		if cad1.end_with?(";")
			cad1=cad1[0,cad1.length-1]
			!CapturarErroresPR(cad1,palabraReservada,index)
		end
	elsif entero==0 && cad1.length>0
		if (operador==">"|| operador=="<")
			!CapturarErroresPR(cad1,palabraReservada,index)
		end
	else
		false
	end
end

def contarTokens(cad,palabraReservada,palabraReservadacont)
	i=0

	while i<cad.length
		cadena2=""
		cad.each_char do |c|
			cadena2+=c
			if cadena2.eql?(palabraReservada[i])
				palabraReservadacont[i]+=1
			end
		end
		i+=1
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
			cad=cad.strip
			bandera=true					#le quito los tabuladores con ese metodo
			if bandera
				if ((cad.include?"=") && (cad.include?("\!")))
					if cad.count("=")==1 && cad.count("\!")==1
						if CapturarErrorOp(cad,"\!",palabraReservada,index)
							operadorescont[12]+=1
						else
							bandera=false
						end
					else
						bandera=false
					end
				elsif ((cad.include?"=") && (cad.include?("<")))
					if cad.count("=")==1 && cad.count("<")==1
						if CapturarErrorOp(cad,"<",palabraReservada,index)
							operadorescont[10]+=1
						else
							bandera=false
						end
					else
						bandera=false
					end
				elsif ((cad.include?"=") && (cad.include?(">")))
					if cad.count("=")==1 && cad.count(">")==1
						if CapturarErrorOp(cad,">",palabraReservada,index)
							operadorescont[9]+=1
						else
							bandera=false
						end
					else
						bandera=false
					end
				elsif cad.count("==")==2
					if CapturarErrorOp(cad,"=",palabraReservada,index)
						operadorescont[6]+=1
					else
						bandera=false
					end
				elsif cad.count("=")==1
					if CapturarErrorOp(cad,"=",palabraReservada,index)
						operadorescont[4]+=cad.count("%")
						operadorescont[5]+=1
					else
						bandera=false
					end
				elsif cad.count(">")==1
					CapturarErrorOp(cad,">",palabraReservada,index) ? operadorescont[8]+=1 : 0
				elsif cad.count("<")==1
					CapturarErrorOp(cad,"<",palabraReservada,index) ? operadorescont[7]+=1 : 0
				end
			end
			if !bandera
				CapturarErroresPR(cad,palabraReservada,index)
			else
				signoscont[0]+=cad.count("(")					#estos métodos todos cuentan cuantos hay en cada linea
				signoscont[1]+=cad.count(")")
				signoscont[4]+=cad.count("\"")
				if cad.include?"{"
					signoscont[2]+=1
				elsif cad.include?"}"
					signoscont[3]+=1
				end
				if cad.end_with?('{') && cad.length>1
					cad=cad[0,cad.length-1]
				elsif cad[0]=="}" && cad.length>1
					cad=cad[1,cad.length]
				end
				if cad.eql?"do"
					palabraReservadacont[7]+=1
				end
				

				if cad.eql?"int"
					palabraReservadacont[0]+=1
				elsif cad.eql?"float"
					palabraReservadacont[1]+=1
				elsif cad.eql?"bool"
					palabraReservadacont[2]+=1
				elsif cad.eql?"string"
					palabraReservadacont[3]+=1
				elsif cad.eql?"else"
					palabraReservadacont[5]+=1
				else
					contarTokens(cad,palabraReservada,palabraReservadacont)
				end
				operadorescont[0]+=cad.count("+")
				operadorescont[1]+=cad.count("-")
				operadorescont[2]+=cad.count("*")
				operadorescont[3]+=cad.count("/")
				if cad.end_with?';'								#si la cadena termina con ";" los tomara todos
					signoscont[5]+=1
				end
			end
			
			
		end 								#termina el if
	elsif array.length==1 && array.length!=0					#de lo contrario si la cadena es 1 sola linea hago lo siguiente
			cad=array[0].strip 				#le vuelvo a quitar los tabuladores en este caso jalo del array =0 porque como es solo 1 vector
			bandera=true
			if bandera
				if ((cad.include?"=") && (cad.include?("\!")))
					if cad.count("=")==1 && cad.count("\!")==1
						if CapturarErrorOp(cad,"\!",palabraReservada,index)
							operadorescont[12]+=1
						else
							bandera=false
						end
					else
						bandera=false
					end
				elsif ((cad.include?"=") && (cad.include?("<")))
					if cad.count("=")==1 && cad.count("<")==1
						if CapturarErrorOp(cad,"<",palabraReservada,index)
							operadorescont[10]+=1
						else
							bandera=false
						end
					else
						bandera=false
					end
				elsif ((cad.include?"=") && (cad.include?(">")))
					if cad.count("=")==1 && cad.count(">")==1
						if CapturarErrorOp(cad,">",palabraReservada,index)
							operadorescont[9]+=1
						else
							bandera=false
						end
					else
						bandera=false
					end
				elsif cad.count("==")==2
					if CapturarErrorOp(cad,"=",palabraReservada,index)
						operadorescont[6]+=1
					else
						bandera=false
					end
				elsif cad.count("=")==1
					operadorescont[4]+=cad.count("%")
					if CapturarErrorOp(cad,"=",palabraReservada,index)
						operadorescont[5]+=1
					else
						bandera=false
					end
				elsif cad.count(">")==1
					CapturarErrorOp(cad,">",palabraReservada,index) ? operadorescont[8]+=1 : 0
				elsif cad.count("<")==1
					CapturarErrorOp(cad,"<",palabraReservada,index) ? operadorescont[7]+=1 : 0
				
				end
			end
			if !bandera
				CapturarErroresPR(cad,palabraReservada,index)
			else
				signoscont[0]+=cad.count("(")	#lo mismo cuento cuantos signos hay en esta linea
				signoscont[1]+=cad.count(")")
				
				
				signoscont[4]+=cad.count("\"")
				if cad.include?"{"
					signoscont[2]+=1
				elsif cad.include?"}"
					signoscont[3]+=1
				end
				if cad.end_with?('{') && cad.length>1
					cad=cad[0,cad.length-1]
				elsif cad[0]==("{") && cad.length>1
					cad=cad[1,cad.length]
				end
				if cad.eql?"do"
					palabraReservadacont[7]+=1
				end
				contarTokens(cad,palabraReservada,palabraReservadacont)
				operadorescont[0]+=cad.count("+")
				operadorescont[1]+=cad.count("-")
				operadorescont[2]+=cad.count("*")
				operadorescont[3]+=cad.count("/")
				
				if cad.end_with?';'
					signoscont[5]+=1
				end
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

