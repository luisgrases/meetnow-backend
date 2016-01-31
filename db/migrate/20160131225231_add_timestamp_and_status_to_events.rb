class AddTimestampAndStatusToEvents < ActiveRecord::Migration
  def change
      add_column(:events, :created_at, :datetime)
      add_column(:events, :updated_at, :datetime)
      add_column(:events, :status, :string, default: :open)
  end
end
