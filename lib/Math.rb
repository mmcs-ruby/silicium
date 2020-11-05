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
#алгоритм Хоара - быстрая сортировка
def quick_sort(a, first, last)
  i=first
  j=last
  x=a[(first+last)/2]
  while (i<=j)
    while (a[i] < x)
      i+=1
    end
    while (a[j] > x)
      j-=1
    end
    if(i <= j)
      if (a[i] > a[j])
        b=a[j]
        a[j]=a[i]
        a[i]=b
      end
      i+=1
      j-=1
    end
  end
  if (i < last)
    quick_sort(a, i, last)
  end
  if (first < j)
    quick_sort(a, first, j)
  end

  return a
end
  end
  end