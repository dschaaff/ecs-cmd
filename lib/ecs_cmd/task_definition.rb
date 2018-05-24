require 'aws-sdk'
require 'terminal-table'

module EcsCmd
  class TaskDefinition
 
    def initialize(task_definition)
      @client = Aws::ECS::Client.new(region: 'us-east-1')
      @task_def = @client.describe_task_definition(task_definition: task_definition)[0]
    end


    def container_defintions
      @task_def['container_definitions']
    end

    def hash
      @task_def.to_hash
    end

    def json
      hash.to_json
    end

  end
end