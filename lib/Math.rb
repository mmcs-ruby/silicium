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
    while a[i] < pivot
      i= i + 1
      while a[j] > pivot
        j= j - 1
        if i >= j
          return j
          swap(a[i],a[j])
        end
      end
    end
    end
end
  end
  end
#алгоритм Хоара - быстрая сортировка
