require 'aws-sdk-ec2'
require 'aws-sdk-ecs'
require 'open3'
require 'shellwords'

module EcsCmd
  module Exec
    class << self
      # move this to a config
      def ssh_cmd(ip)
        cmd = 'ssh -tt -o StrictHostKeyChecking=no '
        cmd << ip.to_s
      end

      def ssh(ip)
        exec(ssh_cmd(ip))
      end

      # used to run arbitrary command inside a container
      def execute(task_family, ip, command)
        cmd = "docker exec -i -t `#{docker_ps_task(task_family)}` #{command}"
        puts ssh_cmd(ip) + " '#{cmd}' " 
        Open3.popen2e(ssh_cmd(ip) + " '#{cmd}' ") do |stdin, stdout, stderr, status_thread|
          stdout.each_line do |line|
            puts line
          end
        end
      end

      # used to open a shell within a container?
      def shell(task_family, ip, shell='bash')
        cmd = "docker exec -i -t `#{docker_ps_task(task_family)}` #{shell}"
        exec(ssh_cmd(ip) + " '#{cmd}' ")
      end

      # docker ps command to get container id 
      def docker_ps_task(task_family)
        "docker ps -n 1 -q --filter name=#{Shellwords.shellescape(task_family)}"
      end
    end
  end
end
