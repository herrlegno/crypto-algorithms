def decomposeToBinary(num)
    n=num.to_s(2).size
    n.times.map{|i| num&(2**i)}.select{ |i| i!=0 }
end

def shiftLeftInRegister(num,size)
    mask=(2**size)-1
    (num << 1)&mask
end

def multiply(a,b)
    iter=b.to_s(2).size
    result=a
    m=0x1B     # 0001 1011 (AES)
    
    iter.times do |i|
        if(i==0)
            next
        end
        
        if(sprintf("%08b", result)[0] == '0')
            result=shiftLeftInRegister(result,8)
        else
            result=shiftLeftInRegister(result,8)^m
        end
    end
    
    return result
end

def multWithXor(a,b)
    arr=decomposeToBinary(b)
    arr.map{|i| multiply(a,i)}.reduce(:^)
end
