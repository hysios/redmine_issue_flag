class AddCreateAtInIssueFlagAndMemberFlag < ActiveRecord::Migration
  def self.up
     add_column :issue_flags, :created_on, :datetime
     add_column :member_flags, :created_on, :datetime
  end

   def self.down
     remove_column :member_flags, :created_on
     remove_column :issue_flags, :created_on
   end  
end
