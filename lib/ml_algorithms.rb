# Class represents computational graph
module BackPropogation
  class ComputationalGraph
    attr_accessor :graph
    def initialize(expr_s)
      expr_proc = ComputationalGraph::PolishParser(expr_s, [])
      pre_graph = []
      @graph = []
      expr_proc.split.each do |elem|
        case elem
        when "+"
          dot = ComputationalGates::Summ_Gate.new(elem)
          dot.connect(pre_graph.pop,pre_graph.pop)
          pre_graph.push(dot)
          @graph.push(dot)
        when "*"
          dot = ComputationalGates::Mult_Gate.new(elem)
          dot.connect(pre_graph.pop,pre_graph.pop)
          pre_graph.push(dot)
          @graph.push(dot)
        when "/"
          dot = ComputationalGates::Div_Gate.new(elem)
          scnd = pre_graph.pop
          frst = pre_graph.pop
          dot.connect(frst,scnd)
          pre_graph.push(dot)
          @graph.push(dot)
        else
          dot = ComputationalGates::Comp_Gate.new(elem)
          pre_graph.push(dot)
          @graph.push(dot)
        end
      end
    end
    #Compute a value of expression
    def ForwardPass(variables_val)
      @graph.each do |elem|
        if elem.class != ComputationalGates::Comp_Gate
          elem.forward_pass
        else
          elem.frwrd = variables_val[elem.name]
        end
      end
      return graph.last.frwrd
    end
    #Compute a gradient value for inputs
    def BackwardPass(loss_value)
      param_grad = Hash.new()
      @graph.last.bckwrd = loss_value
      @graph.reverse.each do |elem|
        if elem.class != ComputationalGates::Comp_Gate
          elem.backward_pass
        else
          param_grad[elem.name] = elem.bckwrd
        end
      end
      return param_grad
    end
    #String preprocessing algorithm expression for computition
    def self.PolishParser(iStr, stack)
      priority = Hash["(" => 0, "+" => 1, "-" => 1, "*" => 2, "/" => 2, "^" => 3]
      case iStr
      when /^\s*([^\+\-\*\/\(\)\^\s]+)\s*(.*)/ then $1 + " " + PolishParser($2, stack)
      when /^\s*([\+\-\*\/\^])\s*(.*)/
        if (stack.empty? or priority[stack.last] < priority[$1]) then PolishParser($2, stack.push($1))
        else stack.pop + " " + PolishParser(iStr, stack) end
      when /^\s*\(\s*(.*)/ then PolishParser($1, stack.push("("))
      when /^\s*\)\s*(.*)/
        if stack.empty? then raise ArgumentError.new "Error: Excess of closing brackets."
        elsif priority[head = stack.pop] > 0 then head + " " + PolishParser(iStr, stack)
        else PolishParser($1, stack) end
      else if stack.empty? then ""
           elsif priority[stack.last] > 0 then stack.pop + " " + PolishParser(iStr, stack)
           else raise ArgumentError.new "Error: Excess of opening brackets." end
      end
    end
  end
  module ComputationalGates
    class Comp_Gate
      attr_accessor :frwrd,:bckwrd,:out,:name
      def initialize(name)
        @name = name
        @frwrd = self
      end
    end
    class Summ_Gate < Comp_Gate
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
    class Mult_Gate < Comp_Gate
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
    class Div_Gate < Comp_Gate
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
