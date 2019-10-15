module Silicium
  class Parser

    def Differentiate(str) # string -> string
      #   class - Elem - от скобки до скобки + степень (^Elem)
      #   class - Multiplication - пара Elem со своей функцией диф.
      #   class - Division - пара Elem со своей функцией диф.
      #   Добавляем в очередь элементы.
      #   Если видим умножение или деление - заменяем Elem на соответствующий класс
      #   (удаляем из очереди, добавляем новый)
      class Elem
        @elem = new.Elem
        @pow = 0
      end
      class Multiplication
        @elem1 = new.Elem
        @elem2 = new.Elem
        def diff
          return @elem1.to_s + "*" + Differentiate(@elem2.to_s) + "+" + @elem2.to_s + "*" + Differentiate(@elem1.to_s)
        end
      end
      class Division
        @elem1 = new.Elem
        @elem2 = new.Elem
        def diff
          return "(" + @elem2.to_s + "*" + Differentiate(@elem1.to_s) + "-" + @elem1.to_s + "*" + Differentiate(@elem2.to_s) + ")"
           + "/" + "(" + @elem2.to_s + "*" + @elem2.to_s + ")"
        end
      end
    end

  end
end