Shoes.app do
   s = stack :width => 200, :height => 200 do
     background red
     hover do
       s.clear { background blue }
     end
     leave do
       s.clear { background red }
     end
   end
 end
 Shoes.app do
   stack margin: 10 do
     para "Pick a card:"
     list_box items: ["Jack", "Ace", "Joker"]
   end
 end
 Shoes.app title: "The Owner" do
   button "Pop up?" do
     window do
       para "Okay, popped up from #{owner}"
     end
   end
 end
 Shoes.app do
   @p = para
   animate do
     button, left, top = self.mouse
     @p.replace "mouse: #{button}, #{left}, #{top}"
   end
 end
 Shoes.app do
   @b = banner "Opacity\n"

   slider fraction: 1.0 do |n|
      app.opacity = n.fraction
      @b.text = "Opacity %.2f\n" % n.fraction
   end
end