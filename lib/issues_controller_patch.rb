require_dependency 'issues_controller'

# Patches Redmine's Issues dynamically.  Adds a relationship 
# Issue +belongs_to+ to Deliverable
module RedmineIssueFlag
  module IssuesControllerPatch
  
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      # Same as typing in the class 
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        
      end

    end
  
    module ClassMethods
    
    end
  
    module InstanceMethods
      # Wraps the association to get the Deliverable subject.  Needed for the 
      # Query and filtering
      def award
        
      end
      
      def punish
        
      end
    end  
  end
  
end