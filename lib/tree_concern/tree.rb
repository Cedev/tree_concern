module TreeConcern
  module Tree
    extend ActiveSupport::Concern
    include TreeConcern::Query
      
    included do
      belongs_to :parent, inverse_of: :children, class_name: name
      has_many :children, foreign_key: "parent_id", class_name: name
      
      scope :roots, -> { where(parent_id: nil) }
      
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
