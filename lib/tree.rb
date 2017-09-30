module Tree
  extend ActiveSupport::Concern
  
  included do
    belongs_to :parent, inverse_of: :children, class_name: name
    has_many :children, foreign_key: "parent_id", class_name: name
    
    validate :parent_cannot_be_descendant
  end
 
  def parent_cannot_be_descendant
    if parent.present? && parent == self
      errors.add(:parent, "can not be self")
    elsif parent.present? && ancestors.include?(self)
      errors.add(:parent, "can not be a descendant")
    end
  end
  
  def ancestors &block
    if block_given?
      parent = self.parent
      while parent
        yield parent
        parent = parent.parent
      end
    else 
      self.to_enum(:ancestors)
    end
  end
  
  def path &block
    self.ancestors.reverse_each &block
  end
  
  def each &block
    if block_given?
      yield self
      self.children.each do |child|
        child.each &block
      end
    else
      self.to_enum(:each)
    end
  end

  def descendants &block
    if block_given?
      self.children.each do |child|
        yield child
        child.descendants &block
      end
    else
      self.to_enum(:descendants)
    end
  end
  
  def each_breadth_first &block
    if block_given?
      yield self
      self.descendants_breadth_first &block
    else
      self.to_enum(:each_breadth_first)
    end
  end
  
  def descendants_breadth_first &block
    if block_given?
      queue = Queue.new
      queue << self
      while !queue.empty? do
        expand = queue.pop
        expand.children.each do |found|
          yield found
          queue << found
        end
      end
    else
      self.to_enum(:descendants_breadth_first)
    end
  end

end
