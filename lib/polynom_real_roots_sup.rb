  module Algebra
    module PolynomRealRootsSupport
      #extend PolynomRealRoot
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
        return [] if res.empty?
        [res.first] + res[1, res.length - 1].map {|x| delim + x }
      end

      def split_by_neg(pos_tokens)
        res = []
        pos_tokens.each do |token|
          res.concat(keep_split(token,'-'))
        end
        res
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
    end
  end
