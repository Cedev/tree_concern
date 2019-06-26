module TreeConcern
  module PolymoprhicTree
    extend ActiveSupport::Concern
    include TreeConcern::Query
      
    included do
      
      class Edge < ActiveRecord::Base
        belongs_to :parent, class_name: parent_name, polymorphic: true
        belongs_to :child, class_name: parent_name, polymorphic: true
      end
      
      has_one :parent_edge, class_name: Edge, :as => :child
      has_many :child_edges, class_name: Edge, :as => :parent
      
      has_one :parent, :through => :parent_edge, :source => :parent
      has_many :children, :through => :child_edges, :source => :child
      
      scope :roots, -> { where(parent: nil) }
      
      validate :parent_cannot_be_descendant
    end
   
    def parent_cannot_be_descendant
      if parent.present? && parent == self
        errors.add(:parent, "can not be self")
      elsif parent.present? && ancestors.include?(self)
        errors.add(:parent, "can not be a descendant")
      end
    end
  
  end
end
