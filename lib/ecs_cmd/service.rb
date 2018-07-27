require 'aws-sdk'
require 'terminal-table'

module EcsCmd
  class Service
    def initialize(cluster, name, region)
      @client = Aws::ECS::Client.new(region: region)
      @service_stats = @client.describe_services(cluster: cluster, services: [name])[0]
    end

    def arn
      begin
        @service_stats[0]['service_arn']
      rescue
        puts 'service does not appear to exist'
      end
    end

    def status
      begin
        @service_stats[0]['status']
      rescue
        puts 'service does not appear to exist'
      end
    end

    def deployments
      begin
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
      rescue
        puts 'service does not appear to exist'
      end
    end

    def deployment_configuration
      begin
        @service_stats[0]['deployment_configuration']
      rescue
        puts 'service does not appear to exist'
      end
    end

    def desired_count
      begin
        @service_stats[0]['desired_count']
      rescue
        puts 'service does not appear to exist'
      end
    end

    def running_count
      begin
        @service_stats[0]['running_count']
      rescue
        puts 'service does not appear to exist'
      end
    end

    def pending_count
      begin
        @service_stats[0]['pending_count']
      rescue
        puts 'service does not appear to exist'
      end
    end

    def task_definition
      begin
        @service_stats[0]['task_definition']
      rescue
       puts 'service does not appear to exist'
      end
    end

    def health_check_grace_period
      begin
        @service_stats[0]['health_check_grace_period_seconds']
      rescue
        puts 'service does not appear to exist'
      end
    end

    def events
      begin
        @service_stats[0]['events'].each do |e|
          puts "#{e['created_at']}: #{e['message']}"
        end
      rescue
        puts 'service does not appear to exist'
      end
    end

    def name
      begin
        @service_stats[0]['service_name']
      rescue
        puts 'service does not appear to exist'
      end
    end

    def list_service
      begin
        row1 = []
        row1 << [name, status, running_count, desired_count, pending_count,
                 deployment_configuration['maximum_percent'], deployment_configuration['minimum_healthy_percent']]
        table1 = Terminal::Table.new headings: ['NAME', 'STATUS', 'RUNNING COUNT',
                                                'DESIRED COUNT', 'PENDING COUNT',
                                                'MAX HEALTHY', 'MIN HEALTHY'], rows: row1
        row2 = []
        row2 << [task_definition]
        table2 = Terminal::Table.new headings: ['TASK DEFINITION'], rows: row2
        puts table1
        puts table2
        puts deployments
      rescue
        puts puts 'service does not appear to exist'
      end
    end
  end
end
