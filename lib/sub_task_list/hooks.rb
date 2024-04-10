module SubTaskList
  class Hooks < Redmine::Hook::ViewListener

    def view_issues_form_details_bottom(context = {})
      sub_task_list = []
      if context[:issue].id.present?
        sub_task_list = Issue.find_by(parent: context[:issue].id)
        if !sub_task_list.present?
          sub_task_list  = []
        end
      end
      context[:controller].send('render_to_string',{
                :partial => 'sub_task_list/edit_sub_task_list_form',
                :locals => {context: context, sub_task_list: sub_task_list}
      })
    end

    def controller_issues_new_after_save(context={})
      items = items_params(context)
      issue = context[:issue]
      save_sub_task_list(items, issue)
    end

    def controller_issues_edit_after_save(context={})
      items = items_params(context)
      issue = context[:issue]
      save_sub_task_list(items, issue)
    end

    private

    def save_sub_task_list(items, issue)
      sub_tasks = []
      items.each do |item|
        sub_task = Issue.new()
        sub_task.tracker_id = issue.tracker_id
        sub_task.project_id = issue.project_id
        sub_task.subject = item["text"]
        sub_task.due_date = issue.due_date
        sub_task.category_id = issue.category_id
        sub_task.assigned_to_id = issue.assigned_to_id
        sub_task.priority_id = issue.priority_id
        sub_task.fixed_version_id = issue.fixed_version_id
        sub_task.author_id = issue.author_id
        sub_task.lock_version = issue.lock_version
        sub_task.start_date = issue.start_date
        sub_task.parent_id = issue.id
        sub_task.root_id = issue.root_id
        sub_task.is_private = issue.is_private
        sub_tasks << sub_task
      end
      sub_tasks.each do |sub_task|
        sub_task.save!
      end
    end

    def items_params(context={})
      if context[:params][:items].present?
        context[:params].require(:items).map do |item|
          item.permit(:text) if !item[:text].blank?
        end.compact
      else
        {}
      end
    end

  end
end
