require 'aws-sdk'
require 'terminal-table'

module EcsCmd
  class Service
    def initialize(cluster, name)
      @client = Aws::ECS::Client.new(region: 'us-east-1')
      @service_stats = @client.describe_services(cluster: cluster, services: [name])[0]
    end
    
    def arn
      @service_stats[0]['service_arn']
    end
    
    def status
      @service_stats[0]['status']
    end
    
    def desired_count
      @service_stats[0]['desired_count']
    end

    def running_count
      @service_stats[0]['running_count']
    end

    def pending_count
      @service_stats[0]['pending_count']
    end

    def task_definition
      @service_stats[0]['task_definition']
    end

    def name
      @service_stats[0]['service_name']
    end
  end
end