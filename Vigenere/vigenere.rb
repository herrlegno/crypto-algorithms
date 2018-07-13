print "Inserta un Mensaje: "
m=gets.chomp.upcase.gsub(/\s+/,'')
print "Introduzca Clave: "
key=gets.chomp.upcase.gsub(/\s+/,'')

m=m.chars
   .each_slice(key.size)
   .to_a
   .map{|i| i.zip(key.chars)}
   .reduce(:+)
   
puts m.map{|i| i[0]}.each_slice(key.size).map{|i| i.reduce(:+)}.to_s
puts m.map{|i| i[1]}.each_slice(key.size).map{|i| i.reduce(:+)}.to_s

c=m.map{|i| (65+((i[0].ord+i[1].ord)%26)).chr}

puts c.each_slice(key.size).map{|i| i.reduce(:+)}.to_s

printf("\n%s: %s\n", "Texto cifrado", c.join)

c=c.each_slice(key.size)
   .to_a
   .map{|i| i.zip(key.chars)}
   .reduce(:+)

c=c.map{|i| (65+((i[0].ord-i[1].ord)%26)).chr}

printf("%s: %s\n", "Texto descifrado", c.join)
