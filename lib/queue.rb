# очередь с приоритетами на базе бинарной кучи
class PQueue

  def initialize(elements=nil, &block)
  @que = []
  @cmp = block || lambda{ |a,b| a <=> b }
  replace(elements) if elements
  end

  protected
  attr_reader :que    # базовая куча

  public
  attr_reader :cmp   # приоритетный компоратор

  # размер очереди
  def size
    @que.size
  end

  # добавление элемента
  def push(v)
    @que << v
    reheap(@que.size-1)
    self
  end

  alias :<< :push

  # возвращает наибольший эл-т очереди(голова) и удаляет его, если очередь пуста - возвращает nil
  def pop
    return nil if empty?
    @que.pop
  end

  # возвращает наименьший эл-т очереди(хвост) и удаляет его, если очередь пуста - возвращает nil
  def shift
    return nil if empty?
    @que.shift
  end

  # возвращает наибольший эл-т очереди(голова)
  def top
    return nil if empty?
    return @que.last
  end

  # возвращает наименьший эл-т очереди(хвост)
  def bottom
    return nil if empty?
    return @que.first
  end

  # добавление сразу нескольких элементов
  # параметр elems должен удовлетворять to_a(~массив)
  #def concat(elems)
  #  if empty?
  #    if elems.kind_of?(PQueue)
  #     initialize_copy(elems)
  #   else
  #     replace(elems)
  #    end
  #  else
  #    if elems.kind_of?(PQueue)
  #     @que.concat(elems.que)
  #     sort!
  #   else
  #     @que.concat(elems.to_a)
  #     sort!
  #   end
  # end
  # return self
  # end

  # возвращает первые n элементов очереди с головы, очередь преобразовывается
  def take(n=@size)
    a = []
    n.times{a.push(pop)}
    a
  end

  # проверка на пустоту
  def empty?
    @que.empty?
  end

  # удаление всех эл-тов из очереди
  def clear
    @que.clear
    self
  end

  # преобразование очереди в массив
  def to_a
    @que.dup
  end

  # заменяет эл-ты очереди на новые элементы(elems)
  # параметр elems должен удовлетворять to_a(~массив)
  def replace(elems)
    if elems.kind_of?(PQueue)
      initialize_copy(elems)
    else
      @que.replace(elems.to_a)
      sort!
    end
    self
  end

  # проверка на наличие эл-та(elem) в очереди
  def include?(elem)
    @que.include?(elem)
  end

  # заменяет наиб эл-т(голову) на elem (приоритетность соблюдается)
  # возвращает удаленную голову
  def swap(elem)
    head = pop
    push(elem)
    head
  end

  # деструктивный перебор всех эл-тов
  def each_pop
    until empty?
      yield if block_given?
      pop
    end
    nil
  end

  # проверка очередей на равнество
  def ==(other)
    size == other.size && to_a == other.to_a
  end

  private
  # копия очереди
  def initialize_copy(other)
    @cmp  = other.cmp
    @que  = other.que.dup
    sort!
  end

  # ставит elem на "свое" место, относительно приоритета
  def reheap(elem)
    return self if size <= 1

    que = @que.dup

    x = que.delete_at(elem)
    ind = binary_index(que, x)

    que.insert(ind, x)

    @que = que

    return self
  end

  # сортировка очереди
  def sort!
    @que.sort! do |a,b|
      case @cmp.call(a,b)
      when  0, nil   then  0
      when  1, true  then  1
      when -1, false then -1
      else
        warn "bad comparison procedure in #{self.inspect}"
        0
      end
    end
    self
  end

  # индекс эл-та x
  def binary_index(que, x)
    upper = que.size - 1
    lower = 0

    while(upper >= lower) do
      ind  = lower + (upper - lower) / 2
      comp = @cmp.call(x, que[ind])

      case comp
      when 0, nil
        return ind
      when 1, true
        lower = ind + 1
      when -1, false
        upper = ind - 1
      else
      end
    end
    lower
    end
end # class PQueue

#временный тест
#q = PQueue.new([2,4,5])
#q << 6
#q << 1
#puts q.to_a

