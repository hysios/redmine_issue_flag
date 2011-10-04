class CreateMemberFlags < ActiveRecord::Migration
  def self.up
    create_table :member_flags do |t|
      t.column :member_id , :integer
      t.column :flags, :integer
    end
  end

  def self.down
    drop_table :member_flags
  end
end
