require "routing"
ActionController::Routing::RouteSet::Mapper.send :include, Yaffle::Routing::MapperExtensions
# File: vendor/plugins/yaffle/lib/routing.rb

module Yaffle #:nodoc:
  module Routing #:nodoc:
    module MapperExtensions
      def yaffles
        @set.add_route("/issue_flag/new", {:controller => "issue_flag_controller", :action => "new"})
      end
    end
  end
end
