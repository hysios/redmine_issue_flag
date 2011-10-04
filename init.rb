require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'
require 'issue_patch'
require 'query_patch'

Dispatcher.to_prepare do
  Issue.send(:include, RedmineIssueFlag::IssuePatch)
  Query.send(:include, RedmineIssueFlag::QueryPatch)
end

require_dependency 'issue_flag_hook'

Redmine::Plugin.register :redmine_issue_flag do
  name 'Redmine Issue Flag plugin'
  author 'hysios hu'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  project_module :issue_flag do
    permission :issue_flag, { :issue_flag => [:index] }
    permission :award_flag, { }, :require => :admin
        
  end
  
  menu :project_menu, :issue_flag, { :controller => 'issue_flag', :action => 'index' }, :caption => :issue_flag
    
end
