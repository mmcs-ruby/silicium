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
      def step_up(level,kf_dif,root_dif,cur_root_count)
        major = find_major(level, kf_dif[level])
        cur_root_count[level] = 0
        i = 0
        # main loop
        loop do
          edge_left,left_val,sign_left = form_left([i,major,level,root_dif,kf_dif ])
          # if we hit in root(unlikely)
          continue if hit_root([level, edge_left, left_val, root_dif, cur_root_count])
          edge_right,right_val,sigh_right = form_right([i,major,level,root_dif,kf_dif])
          continue if hit_root([level, edge_right, right_val, root_dif, cur_root_count])
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
          root_dif[level][cur_root_count[level]] = binary_root_finder(level, edge_neg, edge_pos, kf_dif[level])
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
    def form_left(args_pack)
      i,major,level,root_dif,kf_dif = args_pack
      edge_left = i.zero? ? -major : root_dif[level-1][i-1]
      left_val = eval_by_kf(level,edge_left,kf_dif[level])
      sign_left = left_val.positive? ? 1 : -1
      return [edge_left,left_val,sign_left]
    end
    def form_right(args_pack)
      i,major,level,root_dif,kf_dif = args_pack
      edge_right = i == cur_root_count[level] ? major : root_dif[level - 1][i]
      right_val = eval_by_kf(level,edge_right,kf_dif[level])
      sigh_right = right_val.positive? ? 1 : -1
      return [edge_right,right_val,sigh_right]
    end


  end
end

class PolynomError < StandardError
end

