Shoes.app(:title => "Boton con selector de archivo",:width => 400, :height => 450, :resizable => true) do
	background rgb(112,128,144), :height => 50
	button "Abrir Archivo", :top =>20, :left => 20 do
		strings =Array.new(12)
		sel = ask_open_file title: "Seleccione un archivo"
		File.open("#{sel}", 'r') do |f1|
			while linea = f1.gets
				linea.each_byte do |c|
					if c!=10
						para linea
					end
				end
			end
		end
	end
end
=begin
haciendo pruebas en esta onda
de lo gráfico
end