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

      def execute(task_family, ip, command, user = 'root', sudo = true)
        cmd = if sudo == true
                "sudo docker exec -i -t -u #{user} `#{docker_ps_task(task_family)}` #{command}"
              else
                "docker exec -i -t -u #{user} `#{docker_ps_task(task_family)}` #{command}"
              end
        exec(ssh_cmd(ip) + " '#{cmd}' ")
      end

      def logs(task_family, ip, lines, sudo)
        cmd = if sudo == true
                "sudo docker logs -f --tail=#{lines} `#{docker_ps_task(task_family)}`"
              else
                "docker logs -f --tail=#{lines} `#{docker_ps_task(task_family)}`"
              end
        exec(ssh_cmd(ip) + " '#{cmd}' ")
      end

      # docker ps command to get container id
      def docker_ps_task(task_family, sudo = true)
        if sudo == true
          "sudo docker ps -n 1 -q --filter name=#{Shellwords.shellescape(task_family)}"
        else
          "docker ps -n 1 -q --filter name=#{Shellwords.shellescape(task_family)}"
        end
      end
    end
  end
end
