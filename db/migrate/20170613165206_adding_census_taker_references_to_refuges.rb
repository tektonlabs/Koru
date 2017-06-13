class AddingCensusTakerReferencesToRefuges < ActiveRecord::Migration[5.0]
  def change
    add_reference :refuges, :census_taker
  end
end
