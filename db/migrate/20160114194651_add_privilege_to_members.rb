class AddPrivilegeToMembers < ActiveRecord::Migration
  def change
    add_column :members, :privilege, :string
  end
end
