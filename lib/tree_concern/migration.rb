module TreeConcern
  module Migration
    extend ActiveSupport::Concern
    
    def add_tree table_name
      add_reference table_name, :parent, foreign_key: {to_table: table_name}
    end
  end
end