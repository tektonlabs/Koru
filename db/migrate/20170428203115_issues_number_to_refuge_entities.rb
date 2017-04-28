class IssuesNumberToRefugeEntities < ActiveRecord::Migration[5.0]
  def change
    add_column :refuge_entities, :issues_number, :integer, null: false, default: 0
  end
end
