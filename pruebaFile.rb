  Shoes.app do
   filename = ask_open_file
   # filename = filename.gsub("\\", "/")
   cadena = File.read(filename)
   arreglo = Array.new(1)
   cont=cadena.index(10.chr)
   cadena1=cadena[0,cont]
   arreglo[0]=cadena1
   para "#{cadena.length} #{arreglo[0]}"
 end