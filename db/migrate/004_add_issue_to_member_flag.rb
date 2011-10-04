class AddIssueToMemberFlag < ActiveRecord::Migration
  def self.up
    add_column :member_flags, :issue_id, :integer
    add_column :member_flags, :user_id, :integer
    rename_column :member_flags, :flags , :flag 
    
  end

  def self.down
    rename_column :member_flags, :flag , :flags
    remove_column :member_flags, :issue_id
    remove_column :member_flags, :user_id
  end
end
