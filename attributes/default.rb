#
# Cookbook Name:: duplicity
# Attributes:: default
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

default['duplicity']['install_method']                            =   "package"
default['duplicity']['use_ppa']                                   =   true

default['duplicity']['gpg_passphrase']                            =   ""
default['duplicity']['aws_key_id']                                =   ""
default['duplicity']['aws_secret_access_key']                     =   ""
default['duplicity']['s3_bucket']                                 =   ""
default['duplicity']['s3_use_european_buckets']                   =   false
default['duplicity']['volsize']                                   =   "500"
default['duplicity']['user']                                      =   "root"

default['duplicity']['full_if_older_than']                        =   '1M'
default['duplicity']['full_life']                                 =   '3M'
default['duplicity']['keep_full']                                 =   '1'

default['duplicity']['database']['host']                          =   "localhost"
default['duplicity']['database']['backup_command']                =   "mysqldump --databases \"$BACKUP_DB\" --add-drop-database > \"$BACKUP_PATH/$BACKUP_DB.sql\""
default['duplicity']['database']['restore_command']               =   "mysql < \"$DUMP_PATH\""

default['duplicity']['cron']['enabled']                           =   false
default['duplicity']['cron']['minute']                            =   "0"
default['duplicity']['cron']['hour']                              =   "1"
default['duplicity']['cron']['day']                               =   "*"
default['duplicity']['cron']['month']                             =   "*"
default['duplicity']['cron']['weekday']                           =   "*"

default['duplicity']['remove_script']['cron']['enabled']          =   false
default['duplicity']['remove_script']['cron']['minute']           =   "0"
default['duplicity']['remove_script']['cron']['hour']             =   "8"
default['duplicity']['remove_script']['cron']['day']              =   "*"
default['duplicity']['remove_script']['cron']['month']            =   "*"
default['duplicity']['remove_script']['cron']['weekday']          =   "*"

tmp_dir = "/tmp"
if attribute?("ec2")
  tmp_dir = "/mnt/tmp"
end

default['duplicity']['tmp_dir'] = tmp_dir
default['duplicity']['archive_dir'] = "#{tmp_dir}/.duplicity-archive"