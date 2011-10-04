require_dependency 'issue'

# Patches Redmine's Issues dynamically.  Adds a relationship 
# Issue +belongs_to+ to Deliverable
module RedmineIssueFlag
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      # Same as typing in the class 
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        has_one :issue_flag
        
        attr_accessor :flag
        
        def flag=(value)
          self.issue_flag = self.build_issue_flag(:flag => value) unless self.issue_flag 
          self.issue_flag.flag = value
          self.issue_flag.save
        end
        
        def flag
          @flag ||= self.issue_flag.flag if self.issue_flag
          @flag
        end
        
        def award?
          self.issue_flag && self.issue_flag.state > 0 
        end
        
        def reward
          self.issue_flag.state = 1 if self.issue_flag
        end
      end

    end
  
    module ClassMethods
    
    end
  
    module InstanceMethods
      # Wraps the association to get the Deliverable subject.  Needed for the 
      # Query and filtering
    end    
  end
end


