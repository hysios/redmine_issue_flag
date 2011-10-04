class AddProjectToIssueFlag < ActiveRecord::Migration
  def self.up
    add_column :issue_flags, :project_id, :integer
  end

  def self.down
    remove_column :issue_flags, :project_id
  end
end
