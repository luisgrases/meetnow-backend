class AddFriendshipsAcceptedDefaultValue < ActiveRecord::Migration
  def up
    change_column_default(:friendships, :accepted, false)
  end

  def down
    change_column_default(:friendships, :accepted, nil)
    end
end
