# Class represents computational graph
module BackPropogation
  class ComputationalGraph

    PRIORITY = Hash['(' => 0, '+' => 1, '-' => 1, '*' => 2, '/' => 2, '^' => 3]
    TEMPLATES = {
        operand: /^\s*([^\+\-\*\/\(\)\^\s]+)\s*(.*)/,
        string: /^\s*([\+\-\*\/\^])\s*(.*)/,
        brackets: /^\s*\(\s*(.*)/,
        nested: /^\s*\)\s*(.*)/
    }

    attr_accessor :graph
    def initialize(expr_s)
      exprproc = ComputationalGraph::polish_parser(expr_s, [])
      pregraph = []
      @graph = []
      exprproc.split.each do |elem|
        case elem
        when '+'
          dot = ComputationalGates::SummGate.new(elem)
          dot.connect(pregraph.pop,pregraph.pop)
        when '*'
          dot = ComputationalGates::MultGate.new(elem)
          dot.connect(pregraph.pop,pregraph.pop)
        when '/'
          dot = ComputationalGates::DivGate.new(elem)
          scnd = pregraph.pop
          frst = pregraph.pop
          dot.connect(frst,scnd)
        else
          dot = ComputationalGates::CompGate.new(elem)
        end
        pregraph.push(dot)
        @graph.push(dot)
      end
    end
    #Compute a value of expression
    def forward_pass(variables_val)
      @graph.each do |elem|
        if elem.class != ComputationalGates::CompGate
          elem.forward_pass
        else
          elem.frwrd = variables_val[elem.name]
        end
      end
      graph.last.frwrd
    end
    #Compute a gradient value for inputs
    def backward_pass(loss_value)
      param_grad = Hash.new()
      @graph.last.bckwrd = loss_value
      @graph.reverse.each do |elem|
        if elem.class != ComputationalGates::CompGate
          elem.backward_pass
        else
          param_grad[elem.name] = elem.bckwrd
        end
      end
      param_grad
    end


    def self.parse_operand(left, right, stack)
      left + ' ' + polish_parser(right, stack)
    end

    def self.parse_string(left, right, i_str, stack)
      if stack.empty? || PRIORITY[stack.last] < PRIORITY[left]
        polish_parser(right, stack)
      else 
        stack.pop + ' ' + polish_parser(i_str, stack) 
      end
    end

    def self.parse_nested(left, right, stack)
      raise ArgumentError, 'Error: Excess of closing brackets.' if stack.empty?

      head = stack.pop
      PRIORITY[head].positive? ? head + ' ' + polish_parser(right, stack) : polish_parser(left, stack)
    end

    def self.parse_brackets(left, stack)
      polish_parser(left, stack)
    end

    def self.parse_default(left, stack)
      return '' if stack.empty?
      raise ArgumentError, 'Error: Excess of opening brackets.'  unless PRIORITY[stack.last] > 0

      stack.pop + ' ' + polish_parser(left, stack)
    end
    
    #String preprocessing algorithm expression for computation
    def self.polish_parser(i_str, stack)
      case i_str
      when TEMPLATES[:operand]
        parse_operand(Regexp.last_match(1), Regexp.last_match(2), stack)
      when TEMPLATES[:string]
        parse_string(Regexp.last_match(1), Regexp.last_match(2), i_str, stack)
      when TEMPLATES[:brackets]
        parse_brackets(Regexp.last_match(1), stack.push('('))
      when TEMPLATES[:nested]
        parse_nested(Regexp.last_match(1), i_str, stack)
      else
        parse_default(i_str, stack)
      end
    end
  end

  module ComputationalGates
    class CompGate
      attr_accessor :frwrd,:bckwrd,:out,:name
      def initialize(name)
        @name = name
        @frwrd = self
      end
    end
    class SummGate < CompGate
      attr_accessor :in_frst,:in_scnd
      def initialize(name)
        super(name)
      end
      def connect(f_n,s_n)
        @in_frst = f_n
        @in_scnd = s_n
        f_n.out = self
        s_n.out = self
      end

      def forward_pass()
        @frwrd = @in_frst.frwrd + @in_scnd.frwrd
      end
      def backward_pass()
        @in_frst.bckwrd = @bckwrd
        @in_scnd.bckwrd = @bckwrd
      end

    end
    class MultGate < CompGate
      attr_accessor :in_frst,:in_scnd
      def initialize(name)
        super(name)
      end
      def connect(f_n,s_n)
        @in_frst = f_n
        @in_scnd = s_n
        f_n.out = self
        s_n.out = self
      end
      def forward_pass()
        @frwrd = @in_frst.frwrd * @in_scnd.frwrd
      end
      def backward_pass()
        @in_frst.bckwrd = @bckwrd * @in_scnd.frwrd
        @in_scnd.bckwrd = @bckwrd * @in_frst.frwrd
      end

    end
    class DivGate < CompGate
      attr_accessor :in_frst,:in_scnd
      def initialize(name)
        super(name)
      end
      def connect(f_n,s_n)
        @in_frst = f_n
        @in_scnd = s_n
        f_n.out = self
        s_n.out = self
      end
      def forward_pass()
        @frwrd = @in_frst.frwrd / @in_scnd.frwrd
      end
      def backward_pass()
        @in_frst.bckwrd = @bckwrd * ((-1)/(@in_scnd.frwrd ** 2))
        @in_scnd.bckwrd = @bckwrd * ((-1)/(@in_frst.frwrd ** 2))
      end

    end
  end
end
