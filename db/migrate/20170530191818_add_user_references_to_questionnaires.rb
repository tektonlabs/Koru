class AddUserReferencesToQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    add_reference :questionnaires, :user
  end
end
