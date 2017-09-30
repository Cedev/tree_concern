module TreeConcern
  module Query
    
    def supertrees &block
      if block_given?
        tree = self
        while tree
          yield tree
          tree = tree.parent
        end
      else 
        self.to_enum(:supertrees)
      end
    end
    
    def path &block
      self.supertrees.reverse_each &block
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
    
    def parent_path &block
      self.ancestors.reverse_each &block
    end
    
    def root
      self.supertrees.last
    end
    
    def subtrees &block
      self.depth_first &block
    end
    
    def depth_first &block
      if block_given?
        yield self
        self.children.each do |child|
          child.depth_first &block
        end
      else
        self.to_enum(:depth_first)
      end
    end
    
    def post_order &block
      if block_given?
        self.children.each do |child|
          child.post_order &block
        end
        yield self
      else
        self.to_enum(:post_order)
      end
    end
    
    def breadth_first &block
      if block_given?
        yield self
        self.descendants_breadth_first &block
      else
        self.to_enum(:breadth_first)
      end
    end
    
    def descendants &block
      self.descendants_depth_first &block
    end
  
    def descendants_depth_first &block
      if block_given?
        self.children.each do |child|
          yield child
          child.descendants_depth_first &block
        end
      else
        self.to_enum(:descendants_depth_first)
      end
    end
    
    def descendants_post_order &block
      if block_given?
        self.children.each do |child|
          child.descendants_post_order &block
          yield child
        end
      else
        self.to_enum(:descendants_post_order)
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
  
    def supertree_of?(other)
      self.in?(other.supertrees)
    end
    
    def subtree_of?(other)
      self.supertrees.include?(other)
    end
    
    def ancestor_of?(other)
      self.in?(other.ancestors)
    end
    
    def descendant_of?(other)
      self.ancestors.include?(other)
    end
    
    def child_of?(other)
      self.parent == other
    end
    
    def parent_of?(other)
      other.parent == self
    end
    
    def root_of?(other)
      self.root? && other.root == self
    end

    def root?
      !self.parent
    end
    
    def parent?
      self.children.any?
    end
    
    def child?
      !self.root?
    end
    
  end
end
