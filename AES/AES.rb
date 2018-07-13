require_relative 'mult'

class Matriz < Array
    attr_reader :m, :n
    
    def initialize(m,n,value)
        @m=m
        @n=n
        if value.is_a?String
            value=value.chars.each_slice(2).to_a.map{|i| i.reduce(:+).to_i(16)}
        end
        temp=@n.times.map do |i|
            value.select.with_index{ |val,index| (index>=i*@m && index<(i*@m)+@m)}
        end
        super(temp)
    end
    
    def ^(other)
        if (other.is_a?Matriz) && (@n==other.n && @m==other.m)
            res=self.map.with_index{|val,i| val.zip(other[i]).map{|i| i.reduce(:^)} }.reduce(:+)
            return Matriz.new(@m,@n,res)
        else
           return nil
        end
    end
    
    def addCol(col)
        if (col.is_a?Matriz) && (@m==col.m)
            self.replace(self+col)
            self
        elsif(col.is_a?Array) && (col.size==@m)
            self << col
            self
        else
            return nil
        end
    end
    
    def getSubKey(n)
        self.select.with_index{ |val,index| (index>=n*@m && index<(n*@m)+@m)}
    end
    
    def getStringSubKey(n)
        Matriz.new(@m,@m,getSubKey(n).reduce(:+)).to_s
    end
    
    def to_s
        self.map{|i| i.map{|i| sprintf("%02x",i)}}.reduce(:+).reduce(:+).to_s
    end
end

class AES
    def initialize(c,b)
        @clave=Matriz.new(4,4,c)
        @bloque=Matriz.new(4,4,b)
        @rcon=Matriz.new(4,10,"01000000020000000400000008000000100000002000000040000000800000001b00000036000000")
        @sbox=Matriz.new(16,16,"63cab7040953d051cd60e0e7ba70e18c7c82fdc783d1efa30c8132c8783ef8a177c993232c00aa40134f3a3725b598897b7d26c31aedfb8fecdc0a6d2e66110df2fa36181b2043925f22498d1c4869bf6b593f966efc4d9d972a06d5a603d9e66f47f7055ab133384490244eb4f68e42c5f0cc9aa05b85f517885ca9c60e946830ad3407526a45bcc446c26ce8619b4101d4a5123bcbf9b6a7eed356dd351e9967a2e580d6be02da7eb8acf47457872d2baff1e2b3397f213d1462ea1fb9e90ffe9c71eb294a501064de91654b86ceb0d7a4d827e34c3cff5d5e957abdc15554ab7231b22f589ff3190be4ae8b1d28bb76c0157584cfa8d273db79088a9edf16")
        @mix=Matriz.new(4,4,"02010103030201010103020101010302")
    end
    def cipher
        print "Clave: #{@clave.to_s}\n"
        print "Bloque de Texto Original: #{@bloque.to_s}\n\n"
        expansion=key_expansion
        ciphertext=""
        11.times do |i|
            print "R#{i} "
            if (i==0) #Ronda Inicial
                ciphertext=Matriz.new(4,4,addRoundKey(expansion.getSubKey(i),@bloque.getSubKey(i)).reduce(:+))
                print "(Subclave = #{expansion.getStringSubKey(i)}) = #{ciphertext.to_s}"
            elsif (i==10) #Ronda Final
                ciphertext.map!{|i| subBytes(i)}
                ciphertext=shiftRows(ciphertext)
                ciphertext=Matriz.new(4,4,addRoundKey(ciphertext,expansion.getSubKey(i)).reduce(:+))
                print "(Subclave = #{expansion.getStringSubKey(i)}) = #{ciphertext.to_s}"
            else #Ronda Estándar
                ciphertext.map!{|i| subBytes(i)}
                ciphertext=shiftRows(ciphertext)
                ciphertext=mixColumn(ciphertext)
                ciphertext=Matriz.new(4,4,addRoundKey(ciphertext,expansion.getSubKey(i)).reduce(:+))
                print "(Subclave = #{expansion.getStringSubKey(i)}) = #{ciphertext.to_s}"
            end
            print "\n"
        end
        print "\nBloque de Texto Cifrado: #{ciphertext.to_s}\n"
    end
   
    private
    def key_expansion
        subclaves=@clave
        wi=4
        while wi<44
            if wi%4==0
                colToAdd=subBytes(rotword(subclaves[wi-1])).zip(subclaves[wi-4],@rcon[(wi/4)-1])
                                                           .map{|i| i.reduce(:^)}
                subclaves.addCol(colToAdd)
            else
                colToAdd=subclaves[wi-1].zip(subclaves[wi-4])
                                        .map{|i| i.reduce(:^)}
                subclaves.addCol(colToAdd)
            end
            wi+=1;
        end
        return subclaves
    end
   
    def rotword(col)
        temp=[]
        col.each_with_index do |val,i|
            temp[(i-1)%(col.size)]=val
        end
        return temp
    end
    
    def subBytes(col)
        col.map{|i| sprintf("%02x",i).chars
           .map{|i| i.to_i(16)}}
           .map{|i| @sbox[i[1]][i[0]]}
    end
    
    def shiftRows(mat)
        matRow=mat.n.times.map do |i|
            mat.m.times.map do |j|
                mat[j][i]
            end
        end
        
        4.times.map do |i|
            i.times do 
               matRow[i]=rotword(matRow[i])
            end
        end

        matRow=mat.n.times.map do |i|
            mat.m.times.map do |j|
                matRow[j][i]
            end
        end
    end
    
    def mixColumn(mat)
        mat.map do |ai|
            @mix.m.times.map do |z|
                ai.map.with_index do |aij, j|
                    multWithXor(aij,@mix[j][z])
                end
                .reduce(:^)
            end
        end
    end
    
    def addRoundKey(c1,c2)
        c1.map.with_index{|val,i| val.zip(c2[i])
          .map{|i| i.reduce(:^)}}
    end
end


#GUION
#clave="000102030405060708090a0b0c0d0e0f"
#bloque="00112233445566778899aabbccddeeff"

clave=""
bloque=""

loop do
    print "Introduzca la Clave en Hexadecimal (sin 0x): "
    clave=gets.chomp
    print "Introduzca el Bloque en Hexadecimal (sin 0x): "
    bloque=gets.chomp
    break if (clave =~ /\h/ && bloque =~ /\h/ )
end

AES.new(clave,bloque).cipher