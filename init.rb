require 'redmine'
require_dependency File.expand_path('../lib/sub_task_list/hooks', __FILE__)

Redmine::Plugin.register :sub_task_list do
  name 'redmine sub task list plugin'
  # author 'tiohsa'
  description 'This is a sub task list plugin for Redmine'
  version '0.0.1'
  # url 'https://github.com/tiohsa/sub_task_list'
  # author_url 'https://github.com/tiohsa/sub_task_list'
end
