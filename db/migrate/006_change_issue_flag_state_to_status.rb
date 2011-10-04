class ChangeIssueFlagStateToStatus < ActiveRecord::Migration
  def self.up
    rename_column :issue_flags, :state , :status 
    
  end

  def self.down
    rename_column :issue_flags, :status , :state
  end
end
