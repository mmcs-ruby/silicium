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
      str_var = ''
      parsed = str.split(/[-+]/)
      parsed.each do |term|
        return false if term[/(\s?\d*\s?\*\s?)?([a-z])(\^\d*)?|\s?\d+$/].nil?
        cur_var = $2
        str_var = cur_var if str_var == ''
        return false if !cur_var.nil? && str_var != cur_var
        return false unless letter_controller(term)
      end
      # save variable letter in
      @letter_var = str_var # sorry for that
      return true
    end
    # check for extra letters in term
    def letter_controller(term)
      allowed_w = ['ln','lg','log','cos','sin']
      letters = term.scan(/[a-z]{2,}/)
      letters = letters.join
      return letters.empty? || allowed_w.include?(letters)
    end
    ##
    # +to_ruby_s(val)+ transforms @str into a correct ruby str
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
      # arr[0] = a0 * x^0 ; arr[1] = a1 * x^1 ; ... arr[n] = an * x^(n-1)
      ## get_coef('')    # =>
      def get_coef(str)
        tokens = str.split(/[-+]/)
        cf = Array.new(0.0)
        deg = 0
        tokens.each do |term|
          term[/(\s?\d*[.|,]?\d*\s?)\*?\s?[a-z](\^\d*)?/]
          par_cf = $1
          par_deg = $2
          cur_cf, cur_deg = initialize_cf_deg(term, par_cf, par_deg)
          # initialize deg for the first time
          deg = cur_deg if deg == 0
          # add 0 coefficient to missing degrees
          insert_zeroes(cf, deg - cur_deg - 1) if deg - cur_deg > 1
          cf << cur_cf
          deg = cur_deg
        end
        insert_zeroes(cf, deg) unless deg.zero?
        return cf.reverse
      end
      # intialize cur_cf and cur_deg depend on current term
      def initialize_cf_deg(term,par_cf,par_deg)
        # check that term is free
        if term.scan(/[a-z]/).empty?
          cur_cf = term.to_f
          cur_deg = 0
        else
          cur_cf = par_cf.nil? ? 1 : par_cf.to_f
          cur_deg = par_deg.nil? ? 1 : par_deg.delete('^').to_i
        end
        return [cur_cf,cur_deg]
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
      # this method finds roots for each differentiated polynom and use previous ones to find next one
      # roots located in interval, which has different sign in edges
      # if we've found such interval then we begin binary_search on that interval to find root
      # major is value, which we use to modulate +-infinite
      def step_up(level,cf_dif,root_dif,cur_root_count)
        major = find_major(level, cf_dif[level])
        cur_root_count[level] = 0
        # main loop
        (0..cur_root_count[level-1]).each do |i|
          edge_left,left_val,sign_left = form_left([i,major,level,root_dif,kf_dif ])
          # if we hit in root(unlikely)
          continue if hit_root([level, edge_left, left_val, root_dif, cur_root_count])
          edge_right,right_val,sigh_right = form_right([i,major,level,root_dif,kf_dif])
          continue if hit_root([level, edge_right, right_val, root_dif, cur_root_count])
          continue if sigh_right == sign_left
          if sign_left.negative?
            edge_neg = edge_left
            edge_pos = edge_right
          else
            edge_neg = edge_right
            edge_pos = edge_left
          end
          root_dif[level][cur_root_count[level]] = binary_root_finder(level, edge_neg, edge_pos, cf_dif[level])
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
      # check if we suddenly found root
      def hit_root(arr_pack)
        level,edge,val,root_dif,cur_roots_count = arr_pack
        if val == 0
          root_dif[level][cur_roots_count[level]] = edge
          cur_roots_count[level] += 1
          return true
        end
        return false
      end
    end
    # forming left edge for root search
    def form_left(args_pack)
      i,major,level,root_dif,kf_dif = args_pack
      edge_left = i.zero? ? -major : root_dif[level-1][i-1]
      left_val = eval_by_kf(level,edge_left,kf_dif[level])
      sign_left = left_val.positive? ? 1 : -1
      return [edge_left,left_val,sign_left]
    end
    # forming right edge fro root search
    def form_right(args_pack)
      i,major,level,root_dif,kf_dif = args_pack
      edge_right = i == cur_root_count[level] ? major : root_dif[level - 1][i]
      right_val = eval_by_kf(level,edge_right,kf_dif[level])
      sigh_right = right_val.positive? ? 1 : -1
      return [edge_right,right_val,sigh_right]
    end
    # evaluate real roots of polynom with order = deg
    def polinom_real_roots(deg,coef)
      coef_diff = Array.new(deg + 1)
      root_diff = Array.new(deg + 1)
      cur_root_count = Array.new(deg + 1)
      coef_diff[deg] = rationing_polynom(deg, coef)
      form_coef_diff(deg,coef_diff,cur_root_count,root_diff)
      (2..deg).each {|i| step_up(i,coef_diff,root_diff,cur_root_count)}
      roots_arr = Array.new
      root_diff[deg].each { |root| roots_arr << root }
      return roots_arr
    end
    # rationing polynom
    def rationing_polynom(deg, coef)
      i = 0
      loop do
        res[i] = coef[i] / coef[deg].to_f
        i += 1
        break if i > deg
      end
    end
    # forming array of differentiated polynoms, starting from source one
    def form_coef_diff(deg, coef_diff,cur_root_count,root_dif)
      (deg..2).each do |i|
        str_diff = Algebra::Differentiation.differentiate(coef_to_str(coef_diff[i]))
        coef_diff[i-1] = get_coef(str_diff)
      end
      cur_root_count[1] = 1
      root_diff[1][0] = -coef_diff[1][0]
    end
    # transform array of coefficient to string
    def coef_to_str(coef)
      n = coef.length
      (0..n).each do |i|
        continue if coef[i] == 0
        if i.zero?
          s += "#{coef[i]}"
        else
          s += "#{coef[i]} * x**#{i}"
        end
      end
      return s
    end
  end
end

class PolynomError < StandardError
end