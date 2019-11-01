module Silicium
  module Algebra
    class Differentiation

      def differentiate(str)
        return dif_2(str)
      end

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
          case str[i]
          when '('
            kind_of_a_stack += 1
          when ')'
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
      def fill_var_loop_inner(str,var_hash,ind_hash,ind)
        var_hash[ind_hash] = str[ind+1,ind2-ind-1]
        if (!(str[ind2+1] == '*' && str[ind2+2] == '*'))
          str = str[0,ind2+1] + '**1' + str[ind2+1,str.length-1]
        end
        str = str[0,ind] + '#' + ind_hash.to_s + str[ind2+1,str.length-ind2-1]
        ind_hash += 1
        return [str, var_hash, ind_hash, ind]
      end
      def fill_variables_loop(str,var_hash,ind_hash,ind)
        while (ind != str.length)
          ind2 = find_closing_bracket(str,ind + 1)
          if (str[ind2].nil?)
            puts 'bad string'
          else
            str, var_hash, ind_hash, ind = fill_var_loop_inner(str,var_hash, ind_hash, ind)
          end
          ind = first_char_from(str, '(', 0)
        end
        return [str, var_hash]
      end
      def fill_variables(str)
        var_hash = Hash.new
        ind_hash = 0
        if (str.include?('('))
          ind = first_char_from(str, '(', 0)
          str,var_hash = fill_variables_loop(str,var_hash,ind_hash,ind)
        end
        return [str, var_hash]
      end

      def extract_variables(str,var_hash)
        ind = str[/#(\d+)/,1]
        if (ind.nil?)
          return str
        end
        cur_var = var_hash[ind.to_i]
        while(true)
          str.sub!(/#(\d+)/,cur_var)
          ind = str[/#(\d+)/,1]
          if (ind.nil?)
            return str
          end
          cur_var = var_hash[ind.to_i]
        end
      end

      def run_difs(str)
        return case str
               when /\A-?\d+\Z/
                 '0'
               when /\A-?\d+\*\*+\d+\Z/
                 '0'
               when /\A(-?(\d+[*\/])*)x(\*\*\d+)?([*\/]\d+)*\Z/
                 dif_x($1,$3,$4)
               when /\AMath::(.+)/
                 trigonometry_difs($1)
               else
                 '0'
               end
      end

      def dif_x_a(a)
        if (a.nil? || a == "1*" || a == '')
          a = ""
          a_char = ""
        else
          a_char = a[a.length - 1]
          a = eval(a[0,a.length-1]).to_s
        end
        return [a, a_char]
      end
      def dif_x_c(c)
        if (c.nil? || c == "*1" || c == "/1" || c == '')
          c = ""
          c_char = ""
        else
          c_char = c[0]
          c = eval(c[1,c.length-1]).to_s
        end
        return [c, c_char]
      end
      def dif_x(a,b,c) # a*x^b*c
        a, a_char = dif_x_a(a)
        c, c_char = dif_x_c(c)
        if (b.nil? || b == "**1")
          return eval(a+a_char+"1"+c_char+c).to_s
        else
          new_b = '**' + (b[2,b.length - 2].to_i - 1).to_s
          if (new_b == '**1')
            new_b = ''
          end
          return eval(a+a_char+b[2,b.length - 2]+c_char+c).to_s + '*x' + new_b
        end
      end

      def trigonometry_difs(str)
        return case str
               when /sin<(.+)>/
                 dif_sin($1)
               when /cos<(.+)>/
                 dif_cos($1)

               else
                 '0'
               end
      end
      def dif_sin(param)
        arg = dif_2(param)
        return case arg
               when '0'
                 '0'
               when '1'
                 "Math::cos("+param+")"
               when /\A\d+\Z/
                 "Math::cos("+param+")" + "*" + arg
               else
                 "Math::cos("+param+")" + "*(" + arg + ")"
               end
      end

      def dif_cos(param)
        arg = dif_2(param)
        return case arg
               when '0'
                 '0'
               when '1'
                 "-1*Math::sin("+param+")"
               when /\A\d+\Z/
                 "Math::sin("+param+")" + "*" + eval(arg + '*(-1)').to_s
               else
                 "-1*Math::sin("+param+")" + "*(" + arg + ")"
               end
      end

      def fix_str_for_dif(str)
        str = fix_trig_brackets(str)
        str = fix_useless_brackets(str)
        return str
      end

      def fix_trig_brackets(str)
        reg = /(sin|cos)\((.+)\)/
        cur_el_1 = str[reg,1]
        cur_el_2 = str[reg,2]
        while(!cur_el_1.nil?)
          str.sub!(reg,cur_el_1+'<'+cur_el_2+'>')
          cur_el_1 = str[reg,1]
          cur_el_2 = str[reg,2]
        end
        return str
      end

      def fix_useless_brackets(str)
        reg1 = /\((-?\d+([*\/]\d)*|-?x([*\/]\d)*)\)/
        cur_el = str[reg1,1]
        while (!cur_el.nil?)
          str.sub!(reg1,cur_el)
          cur_el = str[reg1,1]
        end
        return str
      end

      def dif_2(str)
        var_hash = Hash.new
        str = fix_str_for_dif(str)
        str, var_hash = fill_variables(str)
        str.gsub!(/(?!^)-/,'+-')
        summ = str.split('+')
        if (summ.length > 1)
          arr = summ.map{|x|dif_2(extract_variables(x,var_hash))}.select{|x|x!="0"}
          if (arr == [])
            return "0"
          else
            res = arr.join('+')
            res.gsub!('+-','-')
            return res
          end
        end
        str = run_difs(str)
        return str
      end
    end
  end
end

