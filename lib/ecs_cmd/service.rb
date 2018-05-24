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

    def deployments
      t = []
      @service_stats[0]['deployments'].each do |e|
        t << ['id', e['id']]
        t << ['status', e['status']]
        t << ['task definition', e['task_definition']]
        t << ['desired count', e['desired_count']]
        t << ['pending count', e['pending_count']]
        t << ['running count', e['running_count']]
        t << ['created at', e['created_at']]
        t << ['updated at', e['updated_at']]
        t << ["\n"]
      end
      table = Terminal::Table.new headings: ['DEPLOYMENTS'], rows: t
      table
    end

    def deployment_configuration
      @service_stats[0]['deployment_configuration']
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

    def health_check_grace_period
      @service_stats[0]['health_check_grace_period_seconds']
    end

    def events
      @service_stats[0]['events'].each do |e|
        puts "#{e['created_at']}: #{e['message']}"
      end
    end

    def name
      @service_stats[0]['service_name']
    end

    def list_service
      row1 = []
      row1 << [name, status, running_count, desired_count, pending_count,
               deployment_configuration['maximum_percent'], deployment_configuration['minimum_healthy_percent']]
      table1 = Terminal::Table.new headings: ['NAME', 'STATUS', 'RUNNING COUNT',
                                              'DESIRED COUNT', 'PENDING COUNT',
                                              'MAX HEALTHY', 'MIN HEALTHY'], rows: row1
      row2 = []
      row2 << [task_definition]
      table2 = Terminal::Table.new headings: ['CURRENT TASK DEFINITION'], rows: row2
      puts table1
      puts table2
      puts deployments
    end
  end
end
