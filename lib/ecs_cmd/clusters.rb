require 'aws-sdk-ecs'
require 'terminal-table'

module EcsCmd
  class Clusters
    def initialize(region)
      @client = Aws::ECS::Client.new(region: region)
    end

    def get_clusters
      @cluster_arns = @client.list_clusters
    end

    def get_container_instance_count(stats)
      stats['registered_container_instances_count']
    end

    def get_service_count(stats)
      stats['active_services_count']
    end

    def get_running_task_count(stats)
      stats['running_tasks_count']
    end

    def get_pending_task_count(stats)
      stats['pending_tasks_count']
    end

    def cluster_names
      get_clusters[0]
    end

    def list_clusters
      rows = []
      cluster_names.map do |c|
        cluster_name = c.split('/')[1]
        stats = @client.describe_clusters(clusters: [cluster_name])[0][0]
        rows << [cluster_name, get_container_instance_count(stats), get_service_count(stats),
                 get_running_task_count(stats), get_pending_task_count(stats)]
      end
      table = Terminal::Table.new headings: ['CLUSTER NAME', 'CONTAINER_INSTANCE_COUNT',
                                             'SERVICES', 'RUNNING_TASKS', 'PENDING_TASKS'], rows: rows
      puts table
    end
  end
end