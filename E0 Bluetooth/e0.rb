class LFSR
    attr_reader :value
    def initialize(val=0, pol, size)
        @size=size
        @value=val
        @polinomio=pol
    end
    
    def realimentacion
        if @polinomio.is_a?(Array)
            sbin=sprintf("%0#{@size}b", @value)
            acum=@polinomio.map{|val| sbin[val-1].to_i}.reduce(:^)
            push(acum)
        else
            return nil
        end
    end
    
    private 
    def push(bit)
        bitToPush=(2**(@size-1))
        outer=sprintf("%0#{@size}b", @value)[@size-1].to_i
        @value = (bit == 1 ? ((@value >> 1))^(bitToPush) : (@value >> 1))
        return outer
    end
end

class E0cipher
   def initialize(r1, r2, r3, r4, s1)
       @lsfr=[LFSR.new(r1,[25,20,12,8], 25),
              LFSR.new(r2,[31,24,16,12], 31),
              LFSR.new(r3,[33,28,24,4], 33),
              LFSR.new(r4,[39,36,28,4], 39)]
              
        @states=[sprintf("%02b", s1).reverse.to_i(2), s1]
    end
    
    def generador
        4.times do
            p output=@lsfr.map{|i| i.realimentacion}
            p @states
            p "e04=#{e04=output.reduce(:+)+@states[0]}"
            p "z=#{z(e04)}"
            p "t2=#{t2(@states[1])}"
            p "xor1=#{xor1=z(e04)^t2(@states[1])}"
            p "xor2=#{xor2=xor1^t1(@states[0])}"
            p "c0=#{c0=(sprintf("%02b", @states[0])[1].to_i)}"
            p "Bit Generado: #{output.reduce(:^)^c0}"
            @states[0]=sprintf("%02b", xor2).reverse.to_i(2)
            @states[1]=xor2
            printf "---------------\n\n"
        end
        
    end
    
    private
    def t1(r)
        return r
    end
    
    def t2(r)
        strbin=sprintf("%02b", r)
        c0=strbin[1]
        c1=strbin[0]
        return [c0,(c0.to_i^c1.to_i).to_s].reduce(:+).to_i(2)
    end
    def z(n)
        return (n/2)
    end
end

e0 = E0cipher.new(0b0111111111111111111111111, 0b0111111111111111111111111111111, 0b011111111111111111111111111111111, 0b101000000000000000000000000000000001010, 0b01)

e0.generador
