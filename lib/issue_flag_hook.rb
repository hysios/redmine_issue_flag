# Hooks to attach to the Redmine Issues.
class IssueFlagHook < Redmine::Hook::ViewListener

  def view_issues_form_details_bottom(context = { })
    if context[:project].module_enabled?('issue_flag') && User.current.allowed_to?(:award_flag, context[:project])

      @template  = context[:request].env["action_controller.rescue.response"].template
      input = context[:form].text_field :flag 
      return "<p>#{input}</p>"
    else
      return ''
    end
  end

  def view_issues_show_description_bottom(context = {})
    if context[:project].module_enabled?('issue_flag') &&
        User.current.allowed_to?(:award_flag, context[:project]) &&
        !context[:issue].assigned_to_id.blank?
        
        
      input = "<hr/><p><strong>#{l :field_flag} </strong></p>"
      input.concat(label_tag :flag, context[:issue].flag, :style => 'color:red')
      @template = context[:request].env["action_controller.rescue.response"].template

      temp =  @template.content_tag :div, :class => 'contextual' do
        if context[:issue].issue_flag.status != 0
          output = @template.link_to(l(:award),{:action => 'award'}, :id => 'award_button') + " "
          output.concat(@template.link_to(l(:punish), {:action => 'punish'}, :id =>'punish_button'))
          @template.content_for :header_tags do 
            javascript_include_tag "plugin", :plugin => 'redmine_issue_flag' 
          end
          output.concat(@template.content_tag (:script, :type => 'text/javascript') {
            <<-JAVASCRIPT
              bind_award_button(
                'award_button', 
                "/issue_flag/award/", 
                "#{@template.session[:_csrf_token]}", 
                #{context[:issue].id},
                #{context[:issue].flag},
                #{context[:issue].assigned_to_id}
              );
              bind_punish_button('punish_button');
            JAVASCRIPT
          })
          output
        else
          output = @template.content_tag(:span, l(:field_flag_close), :style => 'color:red')
        end
      end
      input.concat(temp)
      
      return "<p>#{input}</p>"
    else
      return ''
    end
  end

  def view_issues_show_details_bottom(context = { }) 
    if context[:project].module_enabled?('issue_flag')
      @template  = context[:request].env["action_controller.rescue.response"].template
      input = @template.label :flag, l(:label_flag)
      input.concat(@template.content_tag(:span, "#{context[:issue].flag}", :style => 'color:red'))
      return "<p>#{input}</p>"
    else
      return ''
    end    
    
  end
  
  def controller_issues_new_before_save(context = {})
    case true
    
    when context[:params][:issue]["flag"].blank?
      # Do nothing
    else
      context[:issue].save!
      context[:issue].flag =  context[:params][:issue]["flag"].to_i
      context[:issue].issue_flag.project_id = context[:issue].project_id
    end

    return ''    
  end
  
  def controller_issues_bulk_edit_before_save(context = { })

  end
  
  def controller_issues_edit_before_save(context = {})
    case true
    
    when context[:params][:issue][:flag].blank?
      # Do nothing
    when !context[:params][:award].blank?
      if context[:params][:award] == "1"
        
      end
    when !context[:params][:punish].blank?
      if context[:params][:punish] == "1"
        
      end
    else
      context[:issue].flag =  context[:params][:issue][:flag].to_i
      context[:issue].issue_flag.project_id = context[:issue].project_id
    end

    return ''    
  end
end