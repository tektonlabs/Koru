class AddingAddressAndStatusToRefuges < ActiveRecord::Migration[5.0]
  def change
    add_column :refuges, :address, :string
    add_column :refuges, :city, :string
    add_column :refuges, :status, :integer, null: false, default: 0
    add_reference :refuges, :country, index: true, foreign_key: true
  end
end
