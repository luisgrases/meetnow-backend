class AddMembersStatusDefaultValue < ActiveRecord::Migration
    def up
    change_column_default(:members, :status, 'pending')
  end

  def down
    change_column_default(:members, :status, nil)
    end
end
