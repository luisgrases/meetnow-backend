class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.belongs_to :event, index: true
      t.belongs_to :user, index: true
      t.string :status
    end
  end
end
