class IssueFlagController < ApplicationController
  unloadable

  def index
    @project = Project.find(params[:id])

    if request.post?
      #Date.civil(params[:start][:"start_date(1i)"].to_i,params[:range][:"start_date(2i)"].to_i,params[:range][:"start_date(3i)"].to_i)
      @start = DateTime.civil(
        params[:start][:year].to_i,
        params[:start][:month].to_i,
        params[:start][:day].to_i,
        params[:start][:hour].to_i,
        params[:start][:minute].to_i)
      @end = DateTime.civil(
        params[:end][:year].to_i, 
        params[:end][:month].to_i, 
        params[:end][:day].to_i,
        params[:end][:hour].to_i,
        params[:end][:minute].to_i)
    else
      @end = DateTime.now
      @start = @end - 7.days
    end
    
    sql = <<-SQL
    select CONCAT(users.firstname,' ',users.lastname) 'name',
        count(issues.id) 'count',
        count(member_flags.id) 'complete',
        sum(issue_flags.flag) 'total',
        sum(member_flags.flag) 'award' 
      from (issues inner join issue_flags on issue_flags.issue_id = issues.id) 
        left join member_flags on member_flags.issue_id = issues.id 
          inner join users on users.id = issues.assigned_to_id
      where issues.project_id = #{@project.id} and issues.created_on between '#{@start.to_formatted_s(:db)}' and '#{@end.to_formatted_s(:db)}' 
      group by users.id;
    SQL
    @issue_flags = Issue.find_by_sql(sql)
    
    
    respond_to do |format|
      format.html { render :index}
    end
    
  end

  def award
    @issue_id = params[:issue_id]
    @issue = Issue.find(@issue_id)
    @flag = params[:flag]
    @issue.issue_flag.status = 0
    @issue.issue_flag.save!
    member_flag = MemberFlag.new(:flag => @flag, :user_id => @issue.assigned_to_id, :issue_id => @issue_id)
    if member_flag.save && @issue.save
      redirect_to(issue_path(@issue), :notice => l(:award_flag_success))
    else
      redirect_to(issue_path(@issue), :error => member_flag.errors.full_messages)
    end
  end
end
