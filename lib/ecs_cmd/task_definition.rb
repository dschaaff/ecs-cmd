require 'aws-sdk'
require 'terminal-table'
require 'ecs_cmd/utils'

module EcsCmd
  class TaskDefinition
    def initialize(task_definition, region)
      @client = Aws::ECS::Client.new(region: region)
      @task_def = @client.describe_task_definition(task_definition: task_definition)[0]
    end


    def container_definitions
      @task_def['container_definitions']
    end
    
    def images
      self.container_definitions.each do |e|
        puts e['image']
      end
    end

    def family
      @task_def['family']
    end

    def revision
      @task_def['revision']
    end

    def volumes
      @task_def['volumes']
    end

    def hash
      @task_def.to_hash
    end

    def json
      hash.to_json
    end
    
    def task_role_arn
      @task_def['task_role_arn']
    end
 
    def update_image(image)
      @new_task_def = @task_def.to_hash
      @new_task_def[:container_definitions].each do |e, i=image|
        if Utils.parse_image_name(e[:image]) == Utils.parse_image_name(i)
          e[:image] = image
        end
      end
      @new_task_def
      resp = register_task_definition(@new_task_def[:family], @new_task_def[:container_definitions], @new_task_def[:volumes], @new_task_def[:task_role_arn])
      resp.task_definition.task_definition_arn
    end

    def register_task_definition(family, container_definitions, volumes, task_role_arn)
      @client.register_task_definition(family: family, container_definitions: container_definitions, volumes: volumes, task_role_arn: task_role_arn)
    end

    def print_json
      puts JSON.pretty_generate(JSON[json])
    end

  end
end