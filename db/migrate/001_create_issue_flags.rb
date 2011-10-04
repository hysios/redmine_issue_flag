class CreateIssueFlags < ActiveRecord::Migration
  def self.up
    create_table :issue_flags do |t|
      t.column :issue_id, :integer
      t.column :flag, :integer
      t.column :state, :integer
    end
  end

  def self.down
    drop_table :issue_flags
  end
end
