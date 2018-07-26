require 'aws-sdk'
require 'terminal-table'

module EcsCmd
  class Services
    def initialize(region)
      @client = Aws::ECS::Client.new(region: region)
    end

    def get_services(cluster)
      @service_arns = []
      @client.list_services(cluster: cluster).each do |r|
        @service_arns << r[0]
        @service_arns.flatten!
      end
      @service_arns
    end

    def list_services(cluster)
      @service_list = get_services(cluster)
      rows = []
      @service_list.map do |service|
        service_name = service.split('/')[1]
        serv = EcsCmd::Service.new(cluster, service_name)
        rows << [service_name, serv.desired_count, serv.running_count, serv.pending_count]
      end
      table = Terminal::Table.new headings: ['SERVICE NAME', 'DESIRED_COUNT',
                                             'RUNNING_COUNT', 'PENDING_COUNT'], rows: rows
      puts table
    end
  end
end
