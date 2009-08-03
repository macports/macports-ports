#!/usr/bin/ruby -w
#
# To customize the below script you must edit values for options:
# base_network_ip
# public_key
# backuppc_ip
#
require 'fileutils'
require 'optparse'
require 'ostruct'
require 'pp'

# set up some defaults
options = OpenStruct.new
options.backuppc_ip = "<backup server ip>"
options.public_key = %Q!<public key from the backuppc user on the backup server!
options.base_network_ip = "<first 3 octets of LAN, e.g. 192.168.1>"
options.verbose = false
options.revert = false
options.user = {}
options.user['name'] = 'backuppc'
options.admin_id = 80
options.backup_check = '/usr/local/bin/backup_check.rb'
options.ip = ''
options.os_version = nil
options.user['passwd'] = 'someveryscarypass'

##########BEGIN SCRIPT METHODS###############
def create_keys2(user,backuppc_ip,public_key,backup_check)
  authorized_keys2 = %Q!from="#{backuppc_ip}",no-pty,command="#{backup_check}" #{public_key}!
  begin
    if !File.exists?("/Users/#{user['name']}/.ssh") then
      FileUtils.mkdir_p "/Users/#{user['name']}/.ssh", :mode => 0700
      File.chown user['uid'], nil, "/Users/#{user['name']}/.ssh"
    end
  rescue
    raise IOError, "Failed to create /Users/#{user['name']}/.ssh"
  end

  begin
    File.open("/Users/#{user['name']}/.ssh/authorized_keys2", 'a+') {|f|
      f.puts authorized_keys2
      File.chown user['uid'], nil, "/Users/#{user['name']}/.ssh/authorized_keys2"
      f.chmod(0600)
    }
  rescue
    raise IOError, "Failed to create /Users/#{user['name']}/.ssh/authorized_keys2"
  end
end

def create_backup_check(admin_id,backup_check)
  ssh_verification_script = %Q!#\!/usr/bin/ruby
#
command = ENV['SSH_ORIGINAL_COMMAND']

if command.nil? || command \!~ /^\\/usr\\/bin\\/sudo \\/usr\\/bin\\/rsync/
  puts "Access Denied"
elsif
  system(command)
end
  !
  begin
    if not File.exists?('/usr/local/bin') then
      FileUtils.mkdir_p '/usr/local/bin', :mode => 0755
    end
  rescue
    raise IOError, "Failed to create /usr/local/bin"
  end

  begin
    File.open(backup_check,'w') {|f|
      f.puts ssh_verification_script
      File.chown 0, admin_id, backup_check
      f.chmod(0755)
    }
  rescue
    raise IOError, "Failed to create /usr/local/bin/backup_check.rb"
  end
end

def edit_sudoers(user,ip)
  begin
    File.open('/etc/sudoers', 'a') do |f|
      f.flock File::LOCK_EX
      rule = "#{user['name']} #{ip}=(root) NOPASSWD: /usr/bin/rsync"
      f.puts rule
      puts "The following rule is now appended to your sudoer file: "
      puts rule
    end
  rescue
    raise IOError, "/etc/sudoers edit failed:"
  end
end

def err(type)
  case type
  when "USERNAME"
    if value.empty? then
    end
  end
end

def valid?(ans)
   return (ans == 'n' or ans == 'y' or ans.empty?)
end

def create_user(user,os_version)
  if os_version  >= "10.5" then
    user['uid'] = `/usr/bin/dscacheutil -q user | grep uid | awk '{print $2}' | grep "4[0123456789][0123456789]"`
  else
    user['uid'] =`/usr/bin/nireport / /users name uid | grep "4[0123456789][0123456789]" | awk '{print $2}'`
  end

  if user['uid'].empty? then
    user['uid'] = 401
  else
    if os_version < "10.5" then
      user['uid'] = user['uid'].split.sort.last.to_i + 1
    else
      user['uid'] = user['uid'].chomp.split.sort.last.to_i + 1
    end
  end
  # Check if the generated user['uid'] is valid, if not raise an error
  if !`/usr/bin/id #{user['uid']} 2>/dev/null`.empty? then
    raise SystemCallError, "Generated uid is in use: please contact the developer with this exception"
  end
  if !`/usr/bin/id #{user['name']} 2>/dev/null`.empty? then
    raise SystemCallError, "Username is in use: Please change the backuppc username or contact the developer with this exception"
  end

  print "Confirm uid #{user['uid']} [y] "
  confirm = gets.chomp.downcase

  # Prompt for user selected user['uid'] until a valid id is found
  while !valid?(confirm)
    puts "Invalid option. Valid options are: [y|n]"
    puts "Confirm uid #{user['uid']} [y]"
    confirm = gets.chomp.downcase
  end

  if confirm == 'n'
    puts "Please enter a valid uid"
    user['uid'] = gets.chomp.to_i
    valid = `/usr/bin/id #{user['uid']}`.empty?
    while !valid
      puts "UID is already in use"
      puts "Please enter a valid uid: "
      user['uid'] = gets.chomp.to_i
      valid = `/usr/bin/id #{user['uid']} 2>/dev/null`.empty?
    end
  end

 # create local user
  if os_version < "10.5" then
    prefix = "/usr/bin/nicl . -create /users/"

    if not system("#{prefix}#{user['name']}") or
       not system("#{prefix}#{user['name']} uid #{user['uid']}") or
       not system("#{prefix}#{user['name']} passwd \"*\"") or
       not system("#{prefix}#{user['name']} gid 20") or
       not system("#{prefix}#{user['name']} shell '/bin/bash'") or
       not system("#{prefix}#{user['name']} home '/Users/#{user['name']}'") or
       not system("#{prefix}#{user['name']} _writers_passwd #{user['name']}") or
       not system("#{prefix}#{user['name']} realname '#{user['name']}'")
      raise SystemCallError, "user creation failed"
    end
  else
    prefix = "/usr/bin/dscl . -create /Users/"
    if not system("#{prefix}#{user['name']}") or
       not system("#{prefix}#{user['name']} UniqueID #{user['uid']}") or
       not system("/usr/bin/dscl . -passwd /Users/#{user['name']} '#{options.user['passwd']}'") or
       not system("#{prefix}#{user['name']} PrimaryGroupID 20") or
       not system("#{prefix}#{user['name']} UserShell /bin/bash") or
       not system("#{prefix}#{user['name']} RealName #{user['name']}") or
       not system("#{prefix}#{user['name']} home /Users/#{user['name']}")

      raise SystemCallError, "user creation failed"
    end
  end

  begin
    FileUtils.mkdir_p "/Users/#{user['name']}", :mode => 0700
  rescue
    raise IOError, "Failed to create the backuppc user directory!"
  end
  if os_version <= "10.5" then
    `/usr/bin/passwd #{user['name']}`
  end
  #set ownership of new home directory to new user user['uid'] and staff(20)
  File.chown user['uid'], 20, "/Users/#{user['name']}"

  return user
end

def get_ip(base_network_ip)
  ip = nil
  ip = `/sbin/ifconfig`.match(/(#{base_network_ip}\.\d+)/)

  if ip.nil?
		ip = ''
		while ip.empty?
    	puts "A valid ip could not be found. Please input your network ip: "
    	ip = gets.chomp
      # in the regex below, insert the first 3 octets of your networks ip
      # for example, if clients receive ip's of 192.168.1.xxx, the regex should be:
      # /192\.168\.1\.\d+
    	ip = '' if !ip.match(/#{base_network_ip}\.\d+/)
  	end
  end

  return ip
end

def hide_user(user,os_version)
  if os_version < "10.5"
    command = '/usr/bin/defaults write /Library/Preferences/com.apple.loginwindow '
    command = command << "HiddenUsersList -array-add #{user['name']}"
  else
    command = "/usr/bin/defaults write /Library/Preferences/com.apple.loginwindow "
    command = command << "Hide500Users -bool YES"
  end
  if not (system(command)) then
    raise SystemCallError, "Failed to hide backuppc user"
  end
end

def revert(user,backup_check,os_version)
  if os_version < "10.5" then
    # delete the created the user
    delete_user_command = "/usr/bin/nicl . delete /users/#{user['name']}"
    # delete the HiddenUsersList
    delete_hide_command = "/usr/bin/defaults delete /Library/Preferences/com.apple.loginwindow HiddenUsersList"
  else
    delete_user_command = "/usr/bin/dscl . delete /Users/#{user['name']}"
    delete_hide_command ="/usr/bin/defaults delete /Library/Preferences/com.apple.loginwindow Hide500Users"
  end

  if not system(delete_user_command) then
    puts "Failed to delete the #{user['name']} user. Perhaps it was never created."
  end

  if not system(delete_hide_command) then
    puts "Failed to delete the Hidden User preference. Perhaps it was never created."
  end

  # remove entry from /etc/sudoers if it exists
  begin
    f = File.new('/etc/sudoers', 'r+')
    f.flock File::LOCK_EX
    lines = f.readlines

    f = f.reopen(f.path, 'w')
    lines.each do |line|
      f.print line unless line.match(/#{user['name']}.*\/usr\/bin\/rsync/)
    end
    f.close
  rescue
    raise IOError, "Editing of /etc/sudoers failed"
  ensure
    f.close if !f.closed?
  end

  # remove the backup_check.rb script
  if File.exists?(backup_check) then
    File.delete(backup_check)
  end
  command = "/usr/sbin/systemsetup -f -setremotelogin off"
  system(command)

  # let admin know backuppc home directory will be left untouched
  puts "WARNING: The backuppc $HOME,/Users/#{user['name']}, will not be removed."
end
def setup_system_prefs
  command = "/usr/sbin/systemsetup -setremotelogin on"
  system(command)
end
def get_os_version
  os_version = `/usr/bin/sw_vers | grep ProductVersion | awk '{print $2}'`
    puts "Detected OS Version: #{os_version}"
    if os_version < "10.4" or os_version >= "10.6" then
      raise ScriptError, "Your version of osx is not supported!"
    end
  return os_version
end
#########END SCRIPT METHODS########
#########BEGIN VARIABLE SETUP#####
options.ip = get_ip(options.base_network_ip)
options.os_version = get_os_version
#########END VARIABLE SETUP#######


########BEGIN SCRIPT###############

opts = OptionParser.new do |opts|
  opts.banner = "Usage: backuppc_config.rb [options]"

  opts.separator "Specific options:"

  opts.on("-h", "--help", "Display this help/usage message") do
    puts opts
    exit
  end

  opts.on("-r", "--revert", "Undo the changes made by script") do
    revert(options.user,options.backup_check,options.os_version)
    exit
  end

end.parse!

puts "Creating backuppc user. . ."

begin
  setup_system_prefs
  create_user(options.user,options.os_version)
  edit_sudoers(options.user, options.ip)
  create_keys2(options.user,options.backuppc_ip,options.public_key,options.backup_check)
  create_backup_check(options.admin_id,options.backup_check)
  hide_user(options.user,options.os_version)
  # Let's go ahead and enter this user into the known_hosts file of the backuppc server user
rescue
  puts "Error: " + $!
end
