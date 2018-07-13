require 'prime'
class DiffieHellman
    def initialize(p,a,xa,xb)
        @p=p
        @a=a
        @xa=xa
        @xb=xb
    end
    
    def cipher
        printf("| %13s | %13s |\n", "----- A -----","----- B -----")
        printf("| %-13s | %-13s |\n", "Xa = #{@xa}", "Xb = #{@xb}")
        printf("| %-13s | %-13s |\n","Ya = #{ya = expRapida(@a,@xa,@p)}", "Yb = #{yb = expRapida(@a,@xb,@p)}")
        printf("| %-13s | %-13s |\n", "K  = #{expRapida(yb,@xa,@p)}","K  = #{expRapida(ya,@xb,@p)}")
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
end

pr=0
q=0
xa=0
xb=0
loop do
    print "P: "
    pr=gets.chomp.to_i
    print "Q: "
    q=gets.chomp.to_i
    print "xA: "
    xa=gets.chomp.to_i
    print "xB: "
    xb=gets.chomp.to_i
    break if (Prime.prime?(pr) && q < pr)
end

DiffieHellman.new(pr,q,xa,xb).cipher
