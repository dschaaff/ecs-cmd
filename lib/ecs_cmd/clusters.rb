require 'aws-sdk'
require 'terminal-table'

module EcsCmd
  class Clusters
    def initialize
      @client = Aws::ECS::Client.new(region: 'us-east-1')
    end

    def get_clusters
      @cluster_arns = @client.list_clusters 
    end

    def get_container_instance_count(cluster)
      @client.list_container_instances(cluster: cluster)[0].length
    end

    def get_service_count
    end

    def get_running_task_count
    end

    def get_pending_task_count
    end

    def list_clusters
      @clusters = get_clusters[0]
      rows = []
      @clusters.map do |c|
        cluster_name = c.split('/')[1] 
        rows << [cluster_name, get_container_instance_count(cluster_name)] 
      end
      table = Terminal::Table.new :headings => ['CLUSTER NAME', 'CONTAINER_INSTANCE_COUNT'], :rows => rows
      puts table
    end
  end
end
