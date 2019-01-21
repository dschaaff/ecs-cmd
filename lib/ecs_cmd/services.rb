require 'aws-sdk-ecs'
require 'terminal-table'

module EcsCmd
  class Services
    def initialize(region, cluster)
      @client = Aws::ECS::Client.new(region: region)
      @reg = region
      @cluster = cluster
    end

    def get_services
      @service_arns = []
      @client.list_services(cluster: @cluster).each do |r|
        @service_arns << r[0]
        @service_arns.flatten!
      end
      @service_arns
    end

    def list_services
      @service_list = get_services
      rows = []
      @service_list.map do |service|
        service_name = service.split(%r{/}).last
        serv = EcsCmd::Service.new(@cluster, service_name, @reg)
        rows << [service_name, serv.desired_count, serv.running_count, serv.pending_count]
      end
      table = Terminal::Table.new headings: ['SERVICE NAME', 'DESIRED_COUNT',
                                             'RUNNING_COUNT', 'PENDING_COUNT'], rows: rows
      puts table
    end
  end
end
