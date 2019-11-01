module Silicium

  class Polynom_division
# This function return an array of coefficients that have received by parsing input string in format: "<coeff>*x**<degree>+..."
# Even if in your expression don't exist x with some degree, you should to write it with 0 coefficient
# Also free term you should to write with 0 degree
# Example: "2*x**5-3*x**4+0*x**3+0*x**2-5*x**1-6*x**0"
    def polynom_parser(str)
      sgn_array = []                    # Array of signs
      if str[0] != '-'
        sgn_array.push('+')
      end
      token = str.split(/[-+]/)
      (0..str.size-1).each do |i|
        if str[i] == '-' || str[i] == '+'
          sgn_array.push(str[i])
        end
      end
      size = token.size - 1
      coeff = Array.new                 # Array of coefficients
      (0..size).each do |i|
        degree = token[i].split('*')    # Split by '*' to get coefficient and degree
        coeff[i]=degree[0].to_f
        if sgn_array[i] == '-'
          coeff[i] *= -1
        end
      end
      coeff
    end

    # This function returns array of 2 strings: first is the result of division polynom poly_1 on polynom poly_2
    # Second - remainder
    def polynom_division(poly_1, poly_2)
      coeff_1 = polynom_parser(poly_1)
      coeff_2 = polynom_parser(poly_2)
      res_size = coeff_1.size - coeff_2.size + 1
      coeff_result = Array.new(res_size)
      sgn_array = Array.new(res_size + 1,'')
      (0..res_size-1).each do |i|
        cur_coeff = coeff_1[i] / coeff_2[0]
        coeff_result[i] = cur_coeff
        if coeff_result[i] < 0
          sgn_array[i] = '-'
        else
          sgn_array[i] = '+'
        end
        (0..coeff_2.size-1).each do |j|
          coeff_1[i+j] -= coeff_2[j]*cur_coeff
        end
      end
      res_exp = ""
      rem_exp = ""
      (0..res_size-1).each do |i|
        res_exp += (coeff_result[i].to_s+"*x**"+(res_size - i - 1).to_s)
        if sgn_array[i+1] != '-'
          res_exp += sgn_array[i+1]
        end
      end
      c = coeff_1.size
      (0..c-1).each do |i|
        if coeff_1[i] > 0.0
          rem_exp += '+'
        end
        if coeff_1[i] != 0.0
          rem_exp += (coeff_1[i].to_s+"*x**"+(c - i - 1).to_s)
        end
      end
      if rem_exp[0] == '+'
        rem_exp[0] = ''
      end
      [res_exp, rem_exp]
    end
  end
end

