 
#clase para abrir el archivo.
#def initialize es el constructor
#def archivo devuelve la variable archivo
class DetectorTokens
	#Declaro los atributos de mi clase me sirven en otro metodos
	attr_accessor :archivo
	attr_accessor :palabraReservada
	attr_accessor :palabraReservadacont
	attr_accessor :operadores
	attr_accessor :operadorescont
	attr_accessor :signos
	attr_accessor :signoscont
	attr_accessor :cont
	attr_accessor :arreglo
	attr_accessor :variablesInt 
	attr_accessor :variablesIntCont
	attr_accessor :variablesFloat     
	attr_accessor :variablesFloatCont 
	attr_accessor :variablesBool      
	attr_accessor :variablesBoolCont  
	attr_accessor :variablesString    
	attr_accessor :variablesStringCont

	def initialize
		@palabraReservada=["int","float","bool","string","if","else","while","do","true","false"]
		@palabraReservadacont=[0,0,0,0,0,0,0,0,0,0]
		@operadores=["+","-","*","/","%","=","==","<",">",">=","<=","\!","\!="]
		@operadorescont=[0,0,0,0,0,0,0,0,0,0,0,0,0]
		@signos=["(",")","{","}","\"",";"]
		@signoscont=[0,0,0,0,0,0]
		@variablesIntCont=Array.new(1)
		@cont=0 #contador que me va a servir para mi array
		@arreglo=Array.new(1) #declaro el array no importa el tamaño
		@variablesInt=Array.new #Array donde se van a guardar las variables
		@variablesIntCont=Array.new
		@variablesFloat=Array.new
		@variablesFloatCont=Array.new
		@variablesBool=Array.new
		@variablesBoolCont=Array.new
		@variablesString=Array.new
		@variablesStringCont=Array.new
		true
	end

	def rutaArchivo(ruta)
		@archivo=File.read(ruta)
	end

	def archivo
		@archivo
	end

	def CapturarErroresPR(cad,index)	#recibe como parametro una cadena, un vector y el indice donde puede ocurrir o no el error
		if ((cad.length>1) && !(cad.eql?"return"))				#si el tamaño de la cadena que recibe es mayor a 1 hace lo siguiente
			k=0
			bandera=[true,true,false]
			while k<cad.length
				cadena1=cad[0,k+1]
				i=0
				while i<@palabraReservada.length&&bandera[1]
					j=0
					
					if cadena1.include?(@palabraReservada[i])
						
						if cad.length>@palabraReservada[i].length
							if !((cadena1.eql?"while") || (cadena1.eql?"if")||(cadena1.eql?"do"))
								if cadena1.eql?(@palabraReservada[i])
									puts "Error en la linea #{index+1} "
									puts "Linea completa con el error #{cad}"
									return true
								else
									cont=0
									if !cad.eql?"false"
										@palabraReservada[i].each_char { |c| cadena1.include?(c) ? cont+=1 :0 }
										if cont==@palabraReservada[i].length
											puts "Error en la linea #{index+1} "
											puts "Linea completa con el error #{cad}"
											return true
										end
									end
								end
							else

								cadena2=cad[cadena1.length,cad.length]
								if !(((cadena1.eql?"while") || (cadena1.eql?"if"))&&(cadena2[0].eql?"("))
									if !((cadena1.eql?"do")&&(cadena2[0].eql?"{"))
										puts "Error en la linea #{index+1} "
										puts "Linea completa con el error #{cad}"
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

							if cadena1.casecmp?(@palabraReservada[i]) && !bandera[2]
								cadena1=cadena1.downcase
								bandera[2]=true
							end

							cont=0	
							@palabraReservada[i].each_char { |c| cadena1.include?(c) ? cont+=1 :0 }
							
							if cont==@palabraReservada[i].length

								puts "Error en la linea #{index+1}"
								puts "Linea completa con el error #{cad}"
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
							if cadena1.downcase.eql?(@palabraReservada[i])
								puts "Error en la linea #{index+1} "
								puts "Linea completa con el error #{cad}"
								bandera[0]=false
								return true
							elsif j==@palabraReservada.length
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

	def CapturarErrorOp(cad,operador,index)
		cont=cad.index(operador)
		cad=cad[(cont+1),cad.length]
		entero=cad.to_i
		if cad[0]=="=" || entero>0 || cad[0]=="0" || entero<0
			return true
		elsif cad[0]=="t" || cad[0]=="f" || cad[0]=="T" || cad[0]=="F"
			if cad.end_with?(";")
				cad=cad[0,cad.length-1]
				if !CapturarErroresPR(cad,index)
					cad.eql?("true") ? @palabraReservadacont[8]+=1 : @palabraReservadacont[9]+=1
					return true
				else
					return false
				end
			end
		elsif entero==0 && cad.length>0
			if (operador==">"|| operador=="<")
				return !CapturarErroresPR(cad,index)
			end
		else
			return false
		end
	end

	def contarTokens(cad)
		i=0
		while i<cad.length
			cadena2=""
			cad.each_char do |c|
				cadena2+=c
				cadena2.eql?(@palabraReservada[i]) ? @palabraReservadacont[i]+=1 : 0
			end
			i+=1
		end
	end

	def BuscarVector(pr,variable)
		variable.end_with?(";") ? variable=variable[0,variable.length-1] : variable
		case pr
		when "int"
			if variablesInt.length==0
				variablesInt[0]=variable
				variablesIntCont[0]=1
			else
				x=0
				encontrado=false
				variablesInt.each_with_index do |var,index| 
					if var.eql?(variable) 
						variablesIntCont[index]+=1 
						encontrado=true 
					else
						x=index
					end
				end
				if !encontrado
					variablesInt[x+1]=variable
					variablesIntCont[x+1]=1
				end
			end
		when "float"
			if variablesFloat.length==0
				variablesFloat[0]=variable
				variablesFloatCont[0]=1
			else
				x=0
				encontrado=false
				variablesFloat.each_with_index do |var,index| 
					if var.eql?(variable) 
						variablesFloatCont[index]+=1 
						encontrado=true 
					else
						x=index
					end
				end
				if !encontrado
					variablesFloat[x+1]=variable
					variablesFloatCont[x+1]=1
				end
			end
		when "bool"
			if variablesBool.length==0
				variablesBool[0]=variable
				variablesBoolCont[0]=1
			else
				x=0
				encontrado=false
				variablesBool.each_with_index do |var,index| 
					if var.eql?(variable) 
						variablesBoolCont[index]+=1 
						encontrado=true 
					else
						x=index
					end
				end
				if !encontrado
					variablesBool[x+1]=variable
					variablesBoolCont[x+1]=1
				end
			end
		when "string"

		end
	end
	def ContarVariables(array,index,pr) 
		#Recibe 3 parametros un vector, el indice de la linea en caso de errores, la palabra reservada ejmp int,float, etc
		#Comparar cada posición del array
		array.each do |var|
			#verifica las variables
			if !var.include?(pr) and !var.include?")"
				if var.count("=")==1
					CapturarErrorOp(var,"=",index)? @operadorescont[5]+=1 : 0
				end
				valor = var.split("=")
				valor.each do |val|
				x=0
					if val.include?("(") 
						x=val.index("(")
						val=val[x+1,val.length]
						CapturarErroresPR(val,index)
					end
				end
				BuscarVector(pr,valor[0])
				#si incluye un símbolo ( es porque es una función con parámetros
			elsif var.include?"("
				valor = var.split("(")
				valor.include?(pr) ? @palabraReservadacont[0]+=1 : 0
				BuscarVector(pr,valor[0])
				#si incluye un símbolo ) es porque es el parámetro de la función
			elsif var.include?")"
 				valor = var.split(")")
				BuscarVector(pr,valor[0])
			end
			if var.end_with?';'								#si la cadena termina con ";" los tomara todos
				@signoscont[5]+=1
				end
			end
	end

	def EjecutarDetector
		while linea=@archivo.gets#mientras tenga lineas el txt va a hacer lo siguiente
			@arreglo[@cont]=linea.chomp #guardo en el array la linea y le quito el salto de linea
			@cont+=1 #incremento cont
		end#termina el while
		@arreglo.each_with_index do |array,index| #each para ir iterrar el vector que en este caso cada posicion del vector es una "linea del txt"
		#puts arreglo[index]
		array=array.split(/ /)			 #Sepraro cada linea si es que se puede en array detectando cada espacio
		cont=0
		array[0].eql?(nil) ? 0 : array[0]=array[0].strip
		if array[0].eql?("int")
			#Comparación: el método main no lo tomará en cuenta, para eso sirve el unless
			unless array.include?"main"
				@palabraReservadacont[0]+=1
				ContarVariables(array,index,"int")
			else
				@palabraReservadacont[0]+=1
			end
		elsif array[0].eql?("float")
			@palabraReservadacont[1]+=1
			ContarVariables(array,index,"float")
		elsif array[0].eql?"bool"
			@palabraReservadacont[2]+=1
			ContarVariables(array,index,"bool")
		elsif array.length!=1 && array.length!=0	##si el array su tamaño es diferente de 1 y de 0 hace lo siguiente
			#puts array[cont]
			array.each do |cad| #each para iterar el array
				#puts cad
				cad=cad.strip     #le quito los tabuladores con ese metodo
				if ((cad.include?"=") && (cad.include?("\!")))
					if cad.count("=")==1 && cad.count("\!")==1
						CapturarErrorOp(cad,"\!",index) ? @operadorescont[12]+=1 : 0
					end
				elsif ((cad.include?"=") && (cad.include?("<")))
					if cad.count("=")==1 && cad.count("<")==1
						CapturarErrorOp(cad,"<",index) ? @operadorescont[10]+=1 : 0
					else
						bandera=false
					end
				elsif ((cad.include?"=") && (cad.include?(">")))
					if cad.count("=")==1 && cad.count(">")==1
						if CapturarErrorOp(cad,">",index)
								@operadorescont[9]+=1
							else
								bandera=false
							end
						else
							bandera=false
						end
					elsif cad.count("==")==2
						if CapturarErrorOp(cad,"=",index)
							@operadorescont[6]+=1
						else
							bandera=false
						end
					elsif cad.count("=")==1
						if CapturarErrorOp(cad,"=",index)
							@operadorescont[4]+=cad.count("%")
							@operadorescont[5]+=1
						else
							bandera=false
						end
					elsif cad.count(">")==1
						CapturarErrorOp(cad,">",index) ? @operadorescont[8]+=1 : 0
					elsif cad.count("<")==1
						CapturarErrorOp(cad,"<",index) ? @operadorescont[7]+=1 : 0
					end

					@signoscont[0]+=cad.count("(")					#estos métodos todos cuentan cuantos hay en cada linea
					@signoscont[1]+=cad.count(")")
					@signoscont[4]+=cad.count("\"")
					if cad.include?"{"
						@signoscont[2]+=1
					elsif cad.include?"}"
						@signoscont[3]+=1
					end
					if cad.end_with?('{') && cad.length>1
						cad=cad[0,cad.length-1]
					elsif cad[0]=="}" && cad.length>1
						cad=cad[1,cad.length]
					end
					#Cuenta la cantidad de variables int que hayan dentro del programa
					
					if cad.eql?"bool"
						@palabraReservadacont[2]+=1
					elsif cad.eql?"string"
						@palabraReservadacont[3]+=1
					elsif cad.eql?"if"
						@palabraReservadacont[4]+=1
					elsif cad.eql?"else"
						@palabraReservadacont[5]+=1
					else
						CapturarErroresPR(cad,index) ? 0 : contarTokens(cad)
					end
					cad.eql?("do") ? @palabraReservadacont[7]+=1 : 0
					@operadorescont[0]+=cad.count("+")
					@operadorescont[1]+=cad.count("-")
					@operadorescont[2]+=cad.count("*")
					@operadorescont[3]+=cad.count("/")
					cad.end_with?(';') ? @signoscont[5]+=1 : 0
				end
		elsif array.length==1 && array.length!=0					#de lo contrario si la cadena es 1 sola linea hago lo siguiente
				cad=array[0].strip 				#le vuelvo a quitar los tabuladores en este caso jalo del array =0 porque como es solo 1 vector
				bandera=true
				if bandera
					if ((cad.include?"=") && (cad.include?("\!")))
						if cad.count("=")==1 && cad.count("\!")==1
							if CapturarErrorOp(cad,"\!",index)
								@operadorescont[12]+=1
							else
								bandera=false
							end
						else
							bandera=false
						end
					elsif ((cad.include?"=") && (cad.include?("<")))
						if cad.count("=")==1 && cad.count("<")==1
							if CapturarErrorOp(cad,"<",index)
								@operadorescont[10]+=1
							else
								bandera=false
							end
						else
							bandera=false
						end
					elsif ((cad.include?"=") && (cad.include?(">")))
						if cad.count("=")==1 && cad.count(">")==1
							if CapturarErrorOp(cad,">",index)
								@operadorescont[9]+=1
							else
								bandera=false
							end
						else
							bandera=false
						end
					elsif cad.count("==")==2
						if CapturarErrorOp(cad,"=",index)
							@operadorescont[6]+=1
						else
							bandera=false
						end
					elsif cad.count("=")==1
						@operadorescont[4]+=cad.count("%")
						if CapturarErrorOp(cad,"=",index)
							@operadorescont[5]+=1
						else
							bandera=false
						end
					elsif cad.count(">")==1
						CapturarErrorOp(cad,">",index) ? @operadorescont[8]+=1 : 0
					elsif cad.count("<")==1
						CapturarErrorOp(cad,"<",index) ? @operadorescont[7]+=1 : 0
					
					end
				end
				if !bandera
					CapturarErroresPR(cad,index)
				else
					@signoscont[0]+=cad.count("(")	#lo mismo cuento cuantos signos hay en esta linea
					@signoscont[1]+=cad.count(")")
					@signoscont[4]+=cad.count("\"")
					if cad.include?"{"
						@signoscont[2]+=1
					elsif cad.include?"}"
						@signoscont[3]+=1
					end
					if cad.end_with?('{') && cad.length>1
						cad=cad[0,cad.length-1]
					elsif cad[0]==("{") && cad.length>1
						cad=cad[1,cad.length]
					end
					cad.eql?("do") ? @palabraReservadacont[7]+=1 : 0
					contarTokens(cad)
					@operadorescont[0]+=cad.count("+")
					@operadorescont[1]+=cad.count("-")
					@operadorescont[2]+=cad.count("*")
					@operadorescont[3]+=cad.count("/")
					cad.end_with?(';') ? @signoscont[5]+=1 : 0
				end
			end
		end
	end
end
#metodo creado por mi solo detecta los errores de palabras reservadas def CapturarErroresPR.
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

 # dTokens=DetectorTokens.new#instancio la clase
 # dTokens.rutaArchivo("C:/Users/hecto/Documents/DetectorTokens/prueba.txt")
 # dTokens.EjecutarDetector
#muestro la cantidad de signos que se encontraron
# for i in (0..dTokens.palabraReservadacont.length-1)
# 	puts "#{i} Se encontraron #{dTokens.palabraReservadacont[i]} veces la palabra reservada #{dTokens.palabraReservada[i]}"
# end
# puts "---------------------------------------------------------"
# for i in (0..dTokens.signoscont.length-1)
# 	puts "Se encontraron #{dTokens.signoscont[i]} veces el signo #{dTokens.signos[i]}"
# end
# puts "---------------------------------------------------------"
# for i in (0..dTokens.operadorescont.length-1)
# 	puts "Se encontraron #{dTokens.operadorescont[i]} veces el operador #{dTokens.operadores[i]}"
# end
# puts "---------------------------------------------------------"
# puts "Variables tipo int"
# x=0
# for i in(0..dTokens.variablesInt.length-1)
# 	puts "#{dTokens.variablesInt[i]} aparece #{dTokens.variablesIntCont[i]}"
# 	x+=dTokens.variablesIntCont[i]
# end
# puts "Cantidad de variables tipo int: #{x}"
# puts "---------------------------------------------------------"
# puts "Variables tipo float"
# x=0
# for i in(0..dTokens.variablesFloat.length-1)
# 	puts "#{dTokens.variablesFloat[i]} aparece #{dTokens.variablesFloatCont[i]}"
# 	x+=dTokens.variablesFloatCont[i]
# end
# puts "Cantidad de variables tipo float: #{x}"
# puts "---------------------------------------------------------"
# puts "Variables tipo bool"
# x=0
# for i in(0..dTokens.variablesBool.length-1)
# 	puts "#{dTokens.variablesBool[i]} aparece #{dTokens.variablesBoolCont[i]}"
# 	x+=dTokens.variablesBoolCont[i]
# end
# puts "Cantidad de variables tipo bool: #{x}"
# puts "---------------------------------------------------------"

class Ventana
	attr_accessor :detector
	attr_accessor :filename
	def initialize
		@filename=""
	end

	def disenio
		Shoes.app :title=>"Detector de Tokens",
			:width=>1100, 
			:height=>525,
		 	:margin=>10,
		 	:resizable => false do
		 	@detector = DetectorTokens.new
		 	@values1 = [24, 22, 10, 13, 8, 22]
		 	@x_axis1 = ['a', 'b', 'c', 'd', 'e', 'f']
		  	background "#02E488".."#220909"
			#Área donde está el texto central
			stack :width =>"100%" do
				@titulo = title "Detector de Tokens"
				@titulo.stroke = "#BF4646"
				@titulo.align = "center"
				@titulo.family = "Comic Sans"
			end

			#Divido la pantalla a la mitad
			stack :width=>"50%" do
				#Uso el 100% de la mitad que partí
				flow :width=>"100%" do

					#Caption para mostrar un texto debajo de una imagen
					@captionSeleccionarArchivo = caption(:top=>320, :left => 150)
					@captionSeleccionarArchivo.text = "Seleccionar Archivo"
					@captionSeleccionarArchivo.size = 12
					
					#Caption para mostrar un texto debajo de una imagen
					@captionPlay = caption(:top=>320, :left=>340)
					@captionPlay.text = "Ejecutar"
					@captionPlay.size = 10

					#Imagen para seleccionar el archivo al que se le van a encontrar los tokens
					@imgSelect = image("seleccionar.png", :top=>140, :left =>170, :width=>100, :height=>100)
					@imgSelect.click do
						@filename = ask_open_file
						@filename = @filename.gsub("\\", "/")
						@captionPath.text = @filename
						if @detector.rutaArchivo(@filename)
							alert "Archivo abierto correctamente"
						else
							alert "archivo no abierto"
						end
						#Por ahora se muestra en el edit_box lo que está en el archivo, pero es solo de prueba. En ese cuadro se van a mostrar
						#los errores que tenga el txt o los tokens que se hallan encontrado
					end

					#Imagen para ejecutar el detector de tokens
					@imgPlay = image("play.png", :top=>140, :left => 320, :width => 100, :height=>100)
					@imgPlay.click do
						@var = @captionPath.text.length
						#Condición para verificar si ya se seleccionó un archivo o no
						unless @var.to_i.zero?
							@detector.EjecutarDetector
							alert "Termine de leer chavo"
							#grafica1
						else
							alert("Seleccione un archivo")
						end
					end

					#Caption que se usa sólo para colocar un texto
					@captionRuta = caption(:top=>170, :left=>60)
					@captionRuta.text = "Ruta: "
					
					#Caption en el que se coloca la ruta del archivo seleccionado
					@captionPath = caption(:top =>170, :left=>120)
					@captionPath.size = 13
					@captionPath.width = 400
				end
			end

			#Se usa la otra mitad de la pantalla que se dividió arriba
			#método para imprimir la gráfica 1
			def grafica1
				stack :width => "50%" do
					flow :width => "100%" do
						widget_width = 500
						widget_height = 400
				
						@grf = plot widget_width, widget_height, title: "Gráfica", caption:
						"Amazing!!", font: "Mono", auto_grid: false,
						default: "skip", background: cornsilk, chart: "pie", boundary_box: false
					end
				end

				@grf.add values: @values1, labels: @x_axis1,
					name: "", min: 0, max: 30, color: rgb(220, 20, 60, 172),
					points: true, strokewidth: 25
			end
		end
	end
end

vent = Ventana.new
vent.disenio