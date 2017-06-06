class CreateRefugeCommittees < ActiveRecord::Migration[5.0]
  def change
    create_table :refuge_committees do |t|
      t.references :refuge, foreign_key: true
      t.references :committee, foreign_key: true

      t.timestamps
    end
  end
end
