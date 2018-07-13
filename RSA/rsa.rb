require 'prime'
class RSA
    def initialize(p,q,d,m)
        @m=m
        @p=p
        @q=q
        @on=(p-1)*(q-1)
        @d=d
        @n=p*q
        @e=euclides(@on,d)
        @c
    end
    
    def cipher();
        m=codificacionMensaje(@m)
        @c=m.map{|i| expRapida(i,@e,@n)}
    end
    
    def decipher()
        @c.map{|i| expRapida(i,@d,@n)}
    end
    
    def to_s
        "p = #{@p}; q = #{@q}; n = #{@n}; on = #{@on}; d = #{@d}; e = #{@e}"
    end
    
    
    def primalidad(n)
        primos=(0..Float::INFINITY).lazy.select{|i| Prime.prime?(i) }.take(2).to_a
        primos.each{|i| return false if((n%i)==0)}
        aleatorios=8.times.map{(2+Random.rand(n-2).round)}
        op=aleatorios.map{|i| expRapida(i,((n-1)/2),n)}
        return false if(op.select{|i| i==1}.size == aleatorios.size);
        op.each{ |i| return false if (i!=1 && i!=n-1) }
        return true
    end
    
    private
    def expRapida(a,b,m)
        x=1
        y=a%m
        while (b>0 && y>1)
            if (!b.even?)
                x=(x*y)%m
                b-=1
            else
                y=(y*y)%m
                b=b/2
            end
        end
        return x
    end
    
    def euclides(a,b)
        xi2,xi,xi1=a,b
        zi2,zi1,zi=0,1,0
        printf("\nEUCLIDES EXTENDIDO\n")
        printf("%6s | %6s\n", "X", "Z")
        printf("------ | ------\n")
        printf("%6s | %6i\n", "-", zi2)
        printf("%6i | %6i\n", xi2, zi1)
        printf("%6i | ", xi)
        while(xi2%xi != 0)
            xi1=xi2%xi
            zi=(zi2-(zi1*(xi2/xi)))%a
            printf("%6i\n%6i | ", zi, xi1)
            xi2=xi
            xi=xi1
            zi2=zi1
            zi1=zi
        end
        printf("\n");
        
        return (xi==1)?zi1:nil
    end
    
    def codificacionMensaje(m)
        bloque=0
        a=@n
        while(a>26)
            a/=26
            bloque+=1
        end
        m.upcase.gsub(/\s+/,'').codepoints.map{|i| i-65}.each_slice(bloque).to_a.map{|i| i.map.with_index{|j,inx| j*(26**(i.size-inx-1))}.reduce(:+)}
    end
end

a=RSA.new(113,887,853,"MANDA DINEROS");
p a.to_s
p "cifrado = #{a.cipher}";
p "descifrado = #{a.decipher}";