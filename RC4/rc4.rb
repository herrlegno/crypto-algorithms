print "Introduzca la semilla: ";
p semilla=gets.chomp.chars.map{|i| i.ord}
print "Introduzca el mensaje: ";
p mensaje=gets.chomp.chars.map{|i| i.ord}

def ksa(semilla)
    s=[]
    k=[]
    256.times{|i|
       s[i]=i;
       k[i]=semilla[i%semilla.size]
    }
    j=0;
    256.times{|i|
        j=(j+s[i]+k[i])%256
        s[i],s[j]=s[j],s[i]
    }
    return s
end

def prga(s,m)
   i,j=0,0
   c=[]
   m.size.times{|x|
        i=(i+1)%256
        j=(j+s[i])%256
        s[i],s[j]=s[j],s[i]
        t=(s[i]+s[j])%256
        c[x]=s[t]^m[x]
        puts "Byte #{x+1} de secuencia cifrante: Salida: S[#{t}]=#{s[t]}   |   #{sprintf("%08b", s[t])}"
        puts "Byte #{x+1} de texto original: Entrada: M[#{x+1}]=#{m[x]}   |   #{sprintf("%08b", m[x])}"
        puts "Byte #{x+1} de texto cifrado: Salida: C[#{x+1}]=#{c[x]}   |   #{sprintf("%08b", c[x])}"
   }
   
   puts "Texto cifrado #{c.to_s}"
   puts "Texto cifrado: #{c.map{|i| i.chr}.reduce(:+)}"
   return c
end

puts "\n--- Cifrado ---"
s=ksa(semilla)
c=prga(s,mensaje)

puts "\n--- Descifrado ---"
s=ksa(semilla)
m=prga(s,c)
