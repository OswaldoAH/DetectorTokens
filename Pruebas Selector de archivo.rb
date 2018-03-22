Shoes.app(:title => "Boton con selector de archivo",:width => 400, :height => 450, :resizable => true) do
	background rgb(112,128,144), :height => 50, :left => 10
	button "Abrir Archivo", :top =>20, :left => 20 do
		sel = ask_open_file title: "Seleccione un archivo"
		para "#{sel}", :top=>300 
   end
 end