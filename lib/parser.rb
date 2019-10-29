module Silicium

  class Polynom
    attr_reader :str

    def initializer(str)
      unless polycop(str)
        raise PolynomError, 'Invalid string for polynom '
      end

      str.gsub!('^','**')
      str.gsub!('tg','tan')
      str.gsub!(/(sin|cos|tan)/,'Math::\1')
      @str = str
    end

    def polycop(str)
      allowed_w = ['sin','cos','tan','tg','ctg','arccos','arcsin']
      parsed = str.split(/[-+]/)
      parsed.each do |term|
        if term[/(\s?\d*\s?\*\s?)?[a-z](\^\d*)?|\s?\d+$/].nil?
          return false
        end
        #check for extra letters in term
        letters = term.scan(/[a-z]{2,}/)
        letters = letters.join
        if letters.length != 0 && !allowed_w.include?(letters)
          return false
        end
      end
      return true
    end

    def evaluate(x)
      res = str.gsub('x',x)
      eval(res)
    end

    def differentiate
      return differentiate_inner(@str)
    end
    def differentiate_inner(str) #string -> string
      ###################################### --METHODS
      def is_digit?(ch)
        if (ch == nil)
          return false
        end
        return (ch >= '0')&&(ch <= '9')
      end
      def fin(fstr)
        if (fstr == '')
          return '0'
        else
          return fstr
        end
      end
      ####################################### --IMPLEMENTATION
      final_str = ''
      cur_elem = ''
      ind = 0

      cur_sym = str[ind]
      if (cur_sym == '-')
        cur_elem += '-'
        ind+=1
        cur_sym = str[ind]
      end
      if (is_digit?(cur_sym))
        while (is_digit?(cur_sym))
          cur_elem = cur_elem + cur_sym
          ind+=1
          cur_sym = str[ind]
        end
        if (cur_sym == '+')
          ind+=1
          final_str = differentiate_inner(str[ind, str.length - ind]) + final_str
        end
        if (cur_sym == '-')
          final_str = differentiate_inner(str[ind, str.length - ind]) + final_str
        end
        if (cur_sym == nil)
          return fin(final_str)
        end
        if (cur_sym == '*')
          final_str = cur_elem + cur_sym + final_str
          ind+=1
          cur_sym = str[ind]
        end
        cur_elem = ''
      end
      if (cur_sym == 'x')
        is_pow = false
        cur_elem += cur_sym
        ind+=1
        cur_sym = str[ind]
        if (cur_sym == nil)
          return final_str + '1'
        end
        if (cur_sym == '*' && str[ind+1] == '*')
          ind+=2
          cur_sym  = str[ind]
          cur_pow = ''
          while (is_digit?(cur_sym))
            cur_pow = cur_pow + cur_sym
            ind += 1
            cur_sym = str[ind]
          end
          if (cur_pow.to_i != 1)
            is_pow = true
          end
          if (cur_pow.to_i == 2)
            final_str = final_str + cur_pow + "*" + cur_elem
          else
            final_str = final_str + cur_pow + "*" + cur_elem + "**" + (cur_pow.to_i - 1).to_s
          end
        end
        if (cur_sym == '+')
          if (is_pow)
            ind+=1
            next_dif = differentiate_inner(str[ind, str.length - ind])
            if (next_dif != '0')
              final_str = final_str + '+' + next_dif
            end
          else
            ind+=1
            next_dif = differentiate_inner(str[ind, str.length - ind])
            if (next_dif != '0')
              final_str = final_str + '1' + '+' + next_dif
            else
              final_str = final_str + '1'
            end

          end
        end
        if (cur_sym == '-')
          if (is_pow)
            final_str = final_str + '-' + differentiate_inner(str[ind, str.length - ind])
          else
            final_str = final_str + '1' + '-' + differentiate_inner(str[ind, str.length - ind])
          end
        end
      end
      return final_str
    end


=begin
    def first_char_from(str, ch, ind)
      i = ind
      while((str[i] != ch) && (i != str.length))
        i+=1
      end
      return i
    end
    def find_closing_bracket(str, ind)
      i = ind
      kind_of_a_stack = 0
      while(i != str.length)
        if(str[i] == '(')
          kind_of_a_stack += 1
        end
        if(str[i] == ')')
          if(kind_of_a_stack == 0)
            return i
          else
            kind_of_a_stack -= 1
          end
        end
        i+=1
      end
      return i
    end
    def dif_2(str)
      var_hash = new.Hash()
      ind_hash = 0
      if (str.include?('('))
        ind = first_char_from(str, '(', 0)
        while (ind != str.length)
          ind2 = find_closing_bracket(str,ind + 1)
          if (str[ind2].null?)
            puts 'bad string'
          else
            var_hash[ind_hash] = str[ind+1,ind2-1]
            if (!(str[ind2+1] == '*' && str[ind2+2] == '*'))
              str = str[0,ind2] + '**1' + str[ind2+1,str.length-1]
            end
            str = str[0,ind-1] + '#' + ind_hash.to_s + str[ind2+1,str.length-1]
            ind_hash += 1
          end
          ind = first_char_from(str, '(', 0)
        end
      end
    end
=end


  end
end
class PolynomError < StandardError
end