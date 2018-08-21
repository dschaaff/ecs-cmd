require 'aws-sdk-ecs'
require 'terminal-table'

module EcsCmd
  class RunTask
    def initialize(region, cluster, task_def, container_name = nil, command = [])
      @client = Aws::ECS::Client.new(region: region)
      @cluster = cluster
      @container_name = container_name
      @task_def = task_def
      @command = command
    end

    # simply run the task
    def run
      puts 'running task...'
      resp = if @container_name
               @client.run_task(cluster: @cluster, task_definition: @task_def, overrides: {
                                  container_overrides: [{
                                    name: @container_name, command: @command
                                  }]
                                })
             else
               @client.run_task(cluster: @cluster, task_definition: @task_def)
             end
      task_arn = resp[0][0]['task_arn']
      result =
        begin
          puts 'waiting for task to complete...'
          @client.wait_until(:tasks_stopped, cluster: @cluster, tasks: [task_arn])
        rescue Aws::Waiters::Errors::WaiterFailed => error
          puts "failed waiting for task to run: #{error.message}"
        end
      puts "task ended with exit code #{result[0][0]['containers'][0]['exit_code']}"
      # return exit code
      raise 'task appears to have failed, check container logs' if result[0][0]['containers'][0]['exit_code'] != 0
    end
  end
end
