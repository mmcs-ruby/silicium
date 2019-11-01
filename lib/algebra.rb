module Silicium

  ##
  # +Algebra+ module helps to perform calculations with polynoms
  module Algebra
    attr_reader :str

    ##
    # +initializer(str)+ creates a correct ruby str from given one
    def initializer(str)
      raise PolynomError, 'Invalid string for polynom ' unless polycop(str)
      @str = str
    end

    ##
    # +polycop(str)+ determines whether the str is an appropriate function
    # which only has one variable
    #
    ## polycop('x^2 + 2 * x + 7')		# => True
    ## polycop('x^2 +2nbbbbb * x + 7')		# => False
    def polycop(str)
      allowed_w = ['ln','lg','log']
      str_var = ''
      parsed = str.split(/[-+]/)
      parsed.each do |term|
        return false if term[/(\s?\d*\s?\*\s?)?([a-z])(\^\d*)?|\s?\d+$/].nil?
        cur_var = $2
        str_var = cur_var if str_var == ''
        return false if !cur_var.nil? && str_var != cur_var
        # check for extra letters in term
        letters = term.scan(/[a-z]{2,}/)
        letters = letters.join
        if !letters.empty? && !allowed_w.include?(letters)
          return false
        end
      end
      # save variable letter in
      @letter_var = str_var # sorry for that
      return true
    end

    ##
    # +to_ruby_s(val)+ transforms @str into a correct ruby stк
    # works for logarithms, trigonometry and misspelled power
    #
    ## to_ruby_s('')    # =>
    def to_ruby_s(val)
      temp_str = @str
      temp_str.gsub!('^','**')
      temp_str.gsub!(/lg|log|ln/,'Math::\1')
      temp_str.gsub!(@letter_var, val)
      return temp_str
    end

    # +evaluate(val)+ counts the result using a given value
    def evaluate(val)
      res = to_ruby_s(val)
      eval(res)
    end


    ##
    # +PolynomRootsReal+
    module PolynomRootsReal

      ##
      # +get_coef(str)+ transforms polynom into array of coefficients
      #
      ## get_coef('')    # =>
      def get_coef(str)
        tokens = str.split(/[-+]/)
        cf = Array.new(0.0)
        deg = 0
        tokens.each do |term|
          term[/(\s?\d*[.|,]?\d*\s?)\*?\s?[a-z](\^\d*)?/]
          par_cf = $1
          par_deg = $2
          # check if term is free term
          if term.scan(/[a-z]/).empty?
            cur_cf = term.to_f
            cur_deg = 0
          else
            cur_cf = par_cf.nil? ? 1 : par_cf.to_f
            cur_deg = par_deg.nil? ? 1 : par_deg.delete('^').to_i
          end
          # initialize deg for the first time
          deg = cur_deg if deg == 0
          # add 0 coefficient to missing degrees
          insert_zeroes(cf, deg - cur_deg - 1) if deg - cur_deg > 1
          cf << cur_cf
          deg = cur_deg
        end
        insert_zeroes(cf, deg) unless deg.zero?
        return cf
      end

      ##
      # +insert_zeroes(arr,count)+ fills empty spaces in the coefficient array
      def insert_zeroes(arr, count)
        loop do
          arr << 0.0
          count -= 1
          break if count == 0
        end
      end

      ##
      # +eval_by_cf(deg,val,cf)+ finds the result of polynom defined by array of coefficients
      def eval_by_cf(deg, val, kf)
        s = 1.0
        i = deg - 1
        loop do
          s = s * val + kf[i]
          i -= 1
          break if i.zero?
        end
        return s
      end

      ##
      # +binary_root_finder(deg,edge_neg,edge_pos,cf)+ finds result of polynom using binary search
      # +edge_neg+ and +edge_pos+ define the interval used for binary search
      def binary_root_finder(deg,edge_neg,edge_pos,cf)
        loop do
          x = 0.5 * (edge_neg + edge_pos)
          return x if x == edge_pos || x == edge_neg
          if eval_by_cf(deg, x, cf) > 0
            edge_pos = x
          else
            edge_neg = x
          end
        end
      end

      ##
      #
      def step_up(level,cf_dif,root_dif,cur_root_count)
        major = find_major(level, cf_dif[level])
        cur_root_count[level] = 0
        i = 0
        # main loop
        loop do
          edge_left = i.zero? ? -major : root_dif[level-1][i-1]
          left_val = eval_by_cf(level, edge_left, cf_dif[level])
          # if we hit in root(unlikely)
          continue if hit_root(level, edge_left, left_val, root_dif, cur_root_count)
          sign_left = left_val.positive? ? 1 : -1
          edge_right = i == cur_root_count[level] ? major : root_dif[level - 1][i]
          right_val = eval_by_cf(level, edge_right, cf_dif[level])
          # if we hit in root(unlikely)
          continue if hit_root(level, edge_right, right_val, root_dif, cur_root_count)
          sigh_right = right_val.positive? ? 1 : -1
          # if sign on edges is equal, there are no roots
          continue if sigh_right == sign_left
          if sign_left.negative?
            edge_neg = edge_left
            edge_pos = edge_right
          else
            edge_neg = edge_right
            edge_pos = edge_left
          end
          # start binary_root_finder
          root_dif[level][cur_root_count[level]] = binary_root_finder(level, edge_neg, edge_pos, cf_dif[level])
          i += 1
          break if i > cur_root_count[level-1]
        end
      end

      ##
      # +find_major(level,cf_dif)+ finds value, which we will use as infinity
      def find_major(level,cf_dif)
        major = 0.0
        i = 0
        loop do
          s = cf_dif[i]
          major = s if s > major
          i += 1
          break if i == level
        end
        return major + 1.0
      end
      def hit_root(level,edge,val,root_dif,cur_roots_count)
        if val == 0
          root_dif[level][cur_roots_count[level]] = edge
          cur_roots_count[level] += 1
          return true
        end
        return false
      end
    end

    ##
    # differentiating methods
    class Differentiation

    ##
    # +differentiate(str)+ differentiates given string
    def differentiate(str)
      return dif_2(str)
    end

    ##
    # +first_char_from(str, ch, ind)+
    def first_char_from(str, ch, ind)
      i = ind
      while(str[i] != ch) && (i != str.length)
        i+=1
      end
      return i
    end

    ##
    # +find_closing_bracket(str,ind)+ finds the first closing bracket in str starting from given index
    def find_closing_bracket(str, ind)
      i = ind
      kind_of_a_stack = 0
      while i != str.length
        if str[i] == '('
          kind_of_a_stack += 1
        elsif str[i] ==  ')'
          kind_of_a_stack -= 1
          if kind_of_a_stack == 0
            return i
          end
        end
        i+=1
      end
      return i
    end

    ##
    # +fill_var_loop_inner(str,var_hash,ind_hash,ind)+
    def fill_var_loop_inner(str,var_hash,ind_hash,ind)
      var_hash[ind_hash] = str[ind+1,ind2-ind-1]
          unless str[ind2+1] == '*' && str[ind2+2] == '*'
            str = str[0,ind2+1] + '**1' + str[ind2+1,str.length-1]
          end
          str = str[0,ind] + '#' + ind_hash.to_s + str[ind2+1,str.length-ind2-1]
          ind_hash += 1
          return [str, var_hash, ind_hash, ind]
    end

    ##
    #
    def fill_variables_loop(str,var_hash,ind_hash,ind)
      while ind != str.length
        ind2 = find_closing_bracket(str,ind + 1)
        if str[ind2].nil?
          puts 'bad string'
        else
          str, var_hash, ind_hash, ind = fill_var_loop_inner(str,var_hash, ind_hash, ind)
        end
      ind = first_char_from(str, '(', 0)
      end
    return [str, var_hash]
    end

    ##
    # +fill_variables(str)+
    def fill_variables(str)
      var_hash = Hash.new
      ind_hash = 0
      if (str.include?('('))
        ind = first_char_from(str, '(', 0)
        str,var_hash = fill_variables_loop(str,var_hash,ind_hash,ind)
      end
      return [str, var_hash]
    end

    ##
    # +extract_variables(str,var_hash)+
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

    ##
    # +run_difs(str)+ selects how to differentiate str
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

    ##
    # +dif_x_a(a)+ goes for variable with a coefficient
    def dif_x_a(a)
      if a.nil? || a == "1*" || a == ''
        a = ""
        a_char = ""
      else
        a_char = a[a.length - 1]
        a = eval(a[0,a.length-1]).to_s
      end
      return [a, a_char]
    end

    ##
    # +dif_x_c(c)+ goes for constant
    def dif_x_c(c)
      if c.nil? || c == "*1" || c == "/1" || c == ''
        c = ""
        c_char = ""
      else
        c_char = c[0]
        c = eval(c[1,c.length-1]).to_s
      end
      return [c, c_char]
    end

    ##
    # +dif_x(a,b,c)+ goes for a*x^b*c
    def dif_x(a,b,c)
      a, a_char = dif_x_a(a)
      c, c_char = dif_x_c(c)
      if b.nil? || b == "**1"
        return eval(a+a_char+"1"+c_char+c).to_s
      else
        new_b = '**' + (b[2,b.length - 2].to_i - 1).to_s
        if new_b == '**1'
          new_b = ''
        end
        return eval(a+a_char+b[2,b.length - 2]+c_char+c).to_s + '*x' + new_b
      end
    end

    ##
    # +trigonometry_difs(str)+ goes for trigonometry
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

    ##
    # +dif_sin(param)+ helps +trigonometry_difs(str)+
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

    ##
    # +dif_cos(param)+ helps +trigonometry_difs(str)+
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

    ##
    # +fix_str_for_dif(str)+ gets rid of useless brackets
    def fix_str_for_dif(str)
      str = fix_trig_brackets(str)
      str = fix_useless_brackets(str)
    end

    ##
    # +fix_trig_brackets(str)+ helps +fix_str_for_dif(str)+ with trigonometry
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

    ##
    # +fix_useless_brackets(str)+ helps +fix_str_for_dif(str)+ with extra brackets
    def fix_useless_brackets(str)
      reg1 = /\((-?\d+([*\/]\d)*|-?x([*\/]\d)*)\)/
      cur_el = str[reg1,1]
      while (!cur_el.nil?)
        str.sub!(reg1,cur_el)
        cur_el = str[reg1,1]
      end
      return str
    end

    ##
    # +dif_2(str)+
    def dif_2(str)
      var_hash = Hash.new
      str = fix_str_for_dif(str)
      str, var_hash = fill_variables(str)
      str.gsub!(/(?!^)-/,'+-')
      summ = str.split('+')
      if summ.length > 1
        arr = summ.map{|x|dif_2(extract_variables(x,var_hash))}.select{|x|x!="0"}
        if arr == []
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

class PolynomError < StandardError
end
