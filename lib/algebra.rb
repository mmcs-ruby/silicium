# frozen_string_literal: true
module Silicium
  require_relative 'algebra_diff'
  require_relative 'polynomial_division'

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
    # +eratosthen_primes_to(n)+ finds all primes up to n
    # with the sieve of eratosthenes
    #
    ## eratosthen_primes_to(1)		# => []
    ## eratosthen_primes_to(15)		# => [2, 3, 5, 7, 11, 13]
    ## eratosthen_primes_to(50)		# => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
    def eratosthen_primes_to(n)
      raise ArgumentError unless valid_n?(n)

      array = (2..n).to_a
      array.each do |prime|
        square = prime**2
        break if square > n

        array -= square.step(n, prime).to_a
      end
      array
    end

    ##
    # Checks if the number n is correct
    def valid_n?(n)
      return false if n <= 0
      return false unless n.class == Integer
      
      true
    end

    ##
    # +polycop(str)+ determines whether the str is an appropriate function
    # which only has one variable
    #
    ## polycop('x^2 + 2 * x + 7')		# => True
    ## polycop('x^2 +2nbbbbb * x + 7')		# => False
    def polycop(str)
      @letter_var = nil
      parsed = str.split(/[-+]/)
      parsed.each do |term|
        return false unless valid_term?(term)
      end
      true
    end

    ##
    # Parses single polynomial term and returns false if
    # term is incorrect on has different independent variable
    # It updated current independent variable if it wasn't set before
    def valid_term?(term)
      correct, cur_var = extract_variable(term)
      return false unless correct

      @letter_var ||= cur_var
      !(another_variable?(@letter_var, cur_var) || !letter_controller(term))
    end

    ##
    # @param [String] expr - part of analytical function that has one independent variable
    # @return [Array]
    # retuns pair, the first value indicates if parsing succeeded, the second is variable
    #
    def extract_variable(expr)
      expr[/(\s?\d*\s?\*\s?)?([a-z])(\^\d*)?|\s?\d+$/]
      [!Regexp.last_match.nil?, Regexp.last_match(2)]
    end

    ##
    # Checks if new variable is present and is not the same as last known variable
    def another_variable?(old_variable, new_variable)
      !new_variable.nil? && old_variable != new_variable
    end

    # check for extra letters in term
    def letter_controller(term)
      allowed_w = %w[ln lg log cos sin]
      letters = term.scan(/[a-z]{2,}/)
      letters = letters.join
      letters.empty? || allowed_w.include?(letters)
    end

    ##
    # +to_ruby_s(val)+ transforms @str into a correct ruby str
    # works for logarithms, trigonometry and misspelled power
    #
    ## to_ruby_s('')    # =>
    def to_ruby_s(val)
      temp_str = @str
      temp_str.gsub!('^', '**')
      temp_str.gsub!(/lg|log|ln/, 'Math::\1')
      temp_str.gsub!(@letter_var, val)
      temp_str
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
        tokens = split_by_op(str)
        cf = Array.new(0.0)
        deg = 0
        tokens.each do |term|
          deg = process_term(term, cf, deg)
        end
        insert_zeroes(cf, deg) unless deg.zero?
        cf.reverse
      end

      def split_by_op(str)
        space_clear_str = str.gsub(/\s/,'')
        pos_tokens = space_clear_str.split('+')
        split_by_neg(pos_tokens)
      end


      def keep_split(str,delim)
        res = str.split(delim)
        return [] if res.length == 0
        [res.first] + res[1,res.length - 1].map {|x| x = delim + x }
      end

      def split_by_neg(pos_tokens)
        res = []
        pos_tokens.each do |token|
          res.concat(keep_split(token, '-'))
        end
        res
      end

      def get_coef_inner(cur_deg, deg)
        deg.zero? ? cur_deg : deg
      end

      def process_term(term, cf, deg)
        term[/(-?\d*[.|,]?\d*)\*?[a-z](\^\d*)?/]
        par_cf = Regexp.last_match(1)
        par_deg = Regexp.last_match(2)
        cur_cf, cur_deg = initialize_cf_deg(term, par_cf, par_deg)
        # initialize deg for the first time
        deg = cur_deg if deg.zero?
        # add 0 coefficient to missing degrees
        insert_zeroes(cf, deg - cur_deg - 1) if deg - cur_deg > 1
        cf << cur_cf
        deg = cur_deg
      end

# intialize cur_cf and cur_deg depend on current term
      def initialize_cf_deg(term, par_cf, par_deg)
        return [term.to_f, 0] if free_term? term
        cf = if par_cf.empty?
               term.include?('-') ? -1 : 1
             else
               par_cf.to_f
             end
        [cf, par_deg.nil? ? 1 : par_deg.delete('^').to_i]
      end

      def free_term?(term)
        term.scan(/[a-z]/).empty?
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
        s = kf[deg]
        i = deg - 1
        loop do
          s = s * val + kf[i]
          i -= 1
          break if i < 0
        end
        s
      end

##
# +binary_root_finder(deg,edge_neg,edge_pos,cf)+ finds result of polynom using binary search
# +edge_neg+ and +edge_pos+ define the interval used for binary search
      def binary_root_finder(deg, edge_neg, edge_pos, cf)
        loop do
          x = 0.5 * (edge_neg + edge_pos)
          return x if [edge_pos, edge_neg].include? x

          if eval_by_cf(deg, x, cf).positive?
            edge_pos = x
          else
            edge_neg = x
          end
        end
        return [edge_pos, edge_neg]
      end

##
# this method finds roots for each differentiated polynom and use previous ones to find next one
# roots located in interval, which has different sign in edges
# if we've found such interval then we begin binary_search on that interval to find root
# major is value, which we use to modulate +-infinite
      def step_up(level, cf_dif, root_dif, cur_root_count)
        major = find_major(level, cf_dif[level])
        cur_root_count[level] = 0
        # main loop
        (0..cur_root_count[level - 1]).each do |i|
          step_up_loop([i, major, level, root_dif, cf_dif, cur_root_count])
        end
      end

      def step_up_loop(arr_pack)
        i, major, level, root_dif, cf_dif, cur_root_count = arr_pack
        edge_left, left_val, sign_left = form_left([i, major, level, root_dif, cf_dif])

        if hit_root([level, edge_left, left_val, root_dif, cur_root_count])
          return
        end
        edge_right, right_val, sigh_right = form_right([i, major, level, root_dif, cf_dif, cur_root_count])

        if hit_root([level, edge_right, right_val, root_dif, cur_root_count])
          return
        end
        return if sigh_right == sign_left
        edge_neg, edge_pos = sign_left.negative? ? [edge_left, edge_right] : [edge_right, edge_left]
        root_dif[level][cur_root_count[level]] = binary_root_finder(level, edge_neg, edge_pos, cf_dif[level])
      end

##
# +find_major(level,cf_dif)+ finds value, which we will use as infinity
      def find_major(level, cf_dif)
        major = 0.0
        i = 0
        loop do
          s = cf_dif[i]
          major = s if s > major
          i += 1
          break if i == level
        end
        major + 1.0
      end

# check if we suddenly found root
      def hit_root(arr_pack)
        level, edge, val, root_dif, cur_roots_count = arr_pack
        if val == 0
          root_dif[level][cur_roots_count[level]] = edge
          cur_roots_count[level] += 1
          return true
        end
        false
      end

# forming left edge for root search
      def form_left(args_pack)
        i, major, level, root_dif, kf_dif = args_pack
        edge_left = i.zero? ? -major : root_dif[level - 1][i - 1]
        left_val = eval_by_cf(level, edge_left, kf_dif[level])
        sign_left = left_val.positive? ? 1 : -1
        [edge_left, left_val, sign_left]
      end

# forming right edge fro root search
      def form_right(args_pack)
        i, major, level, root_dif, kf_dif, cur_root_count = args_pack
        edge_right = i == cur_root_count[level] ? major : root_dif[level - 1][i - 1]

        right_val = eval_by_cf(level, edge_right, kf_dif[level])
        sigh_right = right_val.positive? ? 1 : -1
        [edge_right, right_val, sigh_right]
      end

# evaluate real roots of polynom with order = deg
      def polynom_real_roots(deg, coef)
        coef_diff = Array.new(deg + 1)
        root_diff = Array.new(deg + 1)
        cur_root_count = Array.new(deg + 1)
        coef_diff[deg] = rationing_polynom(deg, coef)
        form_coef_diff(deg, coef_diff, cur_root_count, root_diff)
        (2..deg).each { |i| step_up(i, coef_diff, root_diff, cur_root_count) }
        roots_arr = []
        root_diff[deg].each { |root| roots_arr << root }
        roots_arr
      end


      def polynom_real_roots_by_str(deg, str)
        cf = get_coef(str)
        polynom_real_roots(deg, cf)
      end

# rationing polynom
      def rationing_polynom(deg, coef)
        res = []
        i = 0
        loop do
          res[i] = coef[i] / coef[deg].to_f
          i += 1
          break if i > deg
        end
        res
      end

      def init_coef_diff(coef_diff)
        j = coef_diff.length - 2
        loop do
          coef_diff[j] = []
          j -= 1
          break if j < 0
        end
      end

      def init_root_diff(cur_root_count)
        j = cur_root_count.length - 1
        loop do
          cur_root_count[j] = []
          j -= 1
          break if j < 0
        end
      end

# forming array of differentiated polynoms, starting from source one
      def form_coef_diff(deg, coef_diff, cur_root_count, root_dif)
        init_coef_diff(coef_diff)
        real_differentiration(deg, coef_diff)
        cur_root_count[1] = 1
        init_root_diff(root_dif)
        root_dif[1][0] = -coef_diff[1][0] / coef_diff[1][1]
      end


      def real_differentiration(deg, coef_diff)
        loop do
          j = deg
          loop do
            coef_diff[deg - 1][j - 1] = coef_diff[deg][j] * j

            j -= 1
            break if j.zero?
          end
          deg -= 1
          break if deg < 2
        end
      end

# transform array of coefficient to string
      def coef_to_str(coef)
        n = coef.length - 1
        s = ''
        (0..n).each do |i|
          s += coef_to_str_inner(coef, i, s) unless coef[i].zero?
        end
        s
      end

      def coef_to_str_inner(coef, i, s)
        i.zero? ? coef[i].to_s : "#{sign(coef[i])}#{coef[i]}*x**#{i}"
      end

      def sign(val)
        if val > 0
          '+'
        else
          ''
        end
      end
    end
  end
end
