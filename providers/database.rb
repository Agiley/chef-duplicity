#
# Cookbook Name:: duplicity
# Provider:: database
#
# Copyright 2012, cj Advertising, LLC.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

action :backup do
  bkup_name = new_resource.prefix.nil? ? new_resource.name : new_resource.prefix
  template "/etc/duplicity/backups/db/#{bkup_name}.sh" do
    source "backup_config_db.sh.erb"
    cookbook "duplicity"
    owner node["duplicity"]["user"]
    variables(
      :name => bkup_name,
      :db => new_resource.db
    )
  end
end

action :restore do
  bkup_name = new_resource.prefix.nil? ? new_resource.name : new_resource.prefix
  r = mysql_database "duplicity-#{bkup_name}-restore-check" do
    database_name new_resource.db
    connection ({:host => node['duplicity']['database']['host'], :username => node['duplicity']['database']['user'], :password => node['duplicity']['database']['password']})
    sql "SELECT 1;"
    action :nothing
  end
  r.run_action(:query)
  if !r.updated_by_last_action?
    execute "duplicity-restore-#{bkup_name}-db" do
      user node["duplicity"]["user"]
      command "/etc/duplicity/restore-db.sh '#{bkup_name}'"
    end
  end
end

action :remove do
  bkup_name = new_resource.prefix.nil? ? new_resource.name : new_resource.prefix
  
  file "/etc/duplicity/backups/db/#{bkup_name}.sh" do
    action :delete
    only_if { ::File.exists?("/etc/duplicity/backups/db/#{bkup_name}.sh") }
  end
end