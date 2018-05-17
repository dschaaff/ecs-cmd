require 'aws-sdk'
require 'terminal-table'

module EcsCmd
  class Services
    def initialize
      @client = Aws::ECS::Client.new(region: 'us-east-1')
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
        rows << [service_name]
      end
      table = Terminal::Table.new headings: ['SERVICE NAME'], rows: rows
      puts table
    end
  end
end
