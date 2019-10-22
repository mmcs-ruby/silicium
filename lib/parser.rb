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
  end
end
class PolynomError < StandardError
end
