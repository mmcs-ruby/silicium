module Silicium
  module BinPow
#бинарный алгоритм возведения в степень
def Bin_Pow(a, n)
  result=1
  while (n != 0)
    if (n&1==1)
      result*=a
    end
    a*=a
    n>>=1
  end
  return result
end
public def swap(a,b)
  temp=a
  a=b
  b=temp
end
def quick_sort(a, first, last)
  if first < last
    p = partition(a, first, last)
    quick_sort(a, first, p)
    quick_sort(a, p + 1, last)
  end
end

    def partition(a, low, high)
      pivot= a[(low + high) / 2]
      i= low
      j= high
      while true do
        i=add_inc(a, i, pivot)
        j=dec_j(a,j,pivot)
        if i >= j
          return j
        end
        swap(a[i],a[j])
      end
    end
    def add_inc(a,i,pivot)
      while a[i]>pivot
        i+=1;
      end
      return i;
    end
    def dec_j(a, j, pivot)
      while a[j]>pivot
        j-=1
      end
      return j;
    end
  end
end

#алгоритм Хоара - быстрая сортировка
