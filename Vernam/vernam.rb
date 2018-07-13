def cifrado(m)
    mbin=m.codepoints
    key=m.size.times.map{Random.rand(255)}
    c=mbin.zip(key).map{|i| i[0]^i[1] }
    
    puts "\n---Metodo cifrar---"
    printf("%26s %s\n","Mensaje original (string):", m)
    printf("%26s %s\n","Mensaje original (binary):", mbin.map{|i| sprintf("%08b", i) }.reduce(:+))
    printf("%26s %s\n","Clave aleatoria (binary):", key.map {|i| sprintf("%08b", i) }.reduce(:+))
    printf("%26s %s\n","Mensaje cifrado (binary):", c.map{|i| sprintf("%08b", i) }.reduce(:+))
    printf("%26s %s\n","Mensaje cifrado (string):", c.map{|i| i.chr }.reduce(:+))
end

def descifrado(c,key)
    cb=c.codepoints
        .map{|i| sprintf("%08b", i) }
        .reduce(:+)
        .to_i(2)

    mbin=cb^key
    m=sprintf("%0#{c.size*8}b", mbin).chars
                                     .each_slice(c.size*8/c.size)
                                     .to_a
                                     .map{|i| i.reduce(:+)}
                                     .map{|i| i.to_i(2).chr}
                                     .reduce(:+)

    puts "\n---Metodo descifrar---"
    printf("%26s %s\n","Mensaje cifrado (string):", c)
    printf("%26s %s\n","Mensaje cifrado (binary):", sprintf("%0#{c.size*8}b", cb))
    printf("%26s %s\n","Clave aleatoria (binary):", sprintf("%0#{c.size*8}b", key))
    printf("%26s %s\n","Mensaje original (binary):", sprintf("%0#{c.size*8}b", mbin))
    printf("%26s %s\n","Mensaje original (string):", m)
end

m="SOL"
cifrado(m)

c="[t"
key=0b0000111100100001
descifrado(c,key)
