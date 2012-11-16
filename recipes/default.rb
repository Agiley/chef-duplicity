#
# Cookbook Name:: duplicity
# Recipe:: default
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

package "duplicity"
package "python-boto"

# Create archive folder
directory node["duplicity"]["archive_dir"] do
  owner node["duplicity"]["user"]
  recursive true
end

# Create config folder
directory "/etc/duplicity" do
  owner node["duplicity"]["user"]
  mode "0700"
end

# Create backups folder
directory "/etc/duplicity/backups" do
  owner node["duplicity"]["user"]
  mode "0700"
end

# Create db backups folder
directory "/etc/duplicity/backups/db" do
  owner node["duplicity"]["user"]
  mode "0700"
end

# Create config
template "/etc/duplicity/config.sh" do
  source "config.sh.erb"
  owner node["duplicity"]["user"]
  mode "0600"
end

# Backup script
template "/etc/duplicity/backup.sh" do
  source "backup.sh.erb"
  owner node["duplicity"]["user"]
  mode "0700"
end

# DB backup script
template "/etc/duplicity/backup-db.sh" do
  source "backup-db.sh.erb"
  owner node["duplicity"]["user"]
  mode "0700"
end

# Restore script
template "/etc/duplicity/restore.sh" do
  source "restore.sh.erb"
  owner node["duplicity"]["user"]
  mode "0700"
end

# DB restore script
template "/etc/duplicity/restore-db.sh" do
  source "restore-db.sh.erb"
  owner node["duplicity"]["user"]
  mode "0700"
end

# Install Cron
cron "duplicity-backup-cron" do
  minute node["duplicity"]["cron"]["minute"]
  hour node["duplicity"]["cron"]["hour"]
  day node["duplicity"]["cron"]["day"]
  month node["duplicity"]["cron"]["month"]
  weekday node["duplicity"]["cron"]["weekday"]
  command "/etc/duplicity/backup.sh ; /etc/duplicity/backup-db.sh"
  if node["duplicity"]["cron"]["enabled"]
    action :create
  else
    action :delete
  end
end