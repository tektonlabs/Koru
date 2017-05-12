class AddEntityToNeeds < ActiveRecord::Migration[5.0]
  def change
    add_reference :needs, :entity
  end
end
