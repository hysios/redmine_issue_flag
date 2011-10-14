require_dependency 'query'

# Patches Redmine's Queries dynamically, adding the Deliverable
# to the available query columns
module RedmineIssueFlag
  module QueryColumnPatch

    def value(issue)
      "*" + issue.send(name)
    end
  end
  
  module QueryPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      # Same as typing in the class 
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        flag_column = QueryColumn.new(:flag, :sortable => "#{IssueFlag.table_name}.flag")
        def flag_column.value(issue) 
          value = issue.send(name).to_s || ""
          if !issue.member_flag.nil?
            "+ " + value
          else
            value
          end
        end
        base.available_columns << (flag_column)
      
        alias_method_chain :available_filters, :flags
      end

    end
  
    module ClassMethods
    
      # # Setter for +available_columns+ that isn't provided by the core.
      # def available_columns=(v)
      #   self.available_columns = (v)
      # end
      # 
      # # Method to add a column to the +available_columns+ that isn't provided by the core.
      # def add_available_column(column)
      #   self.available_columns << (column)
      # end
    end
  
    module InstanceMethods
    
      # Wrapper around the +available_filters+ to add a new Deliverable filter

      def available_filters_with_flags
        
        @available_filters = available_filters_without_flags
        if project
          flags_filters = { "flag" => { :type => :list_optional, :order => 14,
              :values => IssueFlag.find(:all, :conditions => ["project_id IN (?)", project], :order => 'flag ASC').collect { |d| [d.flag, d.id.to_s]}
            }}
        else
          flags_filters = { }
        end
        return @available_filters.merge(flags_filters)
      end
    end    
  end
end

