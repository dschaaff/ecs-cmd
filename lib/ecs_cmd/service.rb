require 'aws-sdk-ecs'
require 'aws-sdk-ec2'
require 'terminal-table'

module EcsCmd
# rubocop:disable Metrics/ClassLength
  class Service
    def initialize(cluster, name, region)
      @client = Aws::ECS::Client.new(region: region)
      @ec2_client = Aws::EC2::Client.new(region: region)
      @cluster = cluster
      @name = name
      @service_stats = @client.describe_services(cluster: cluster, services: [name])[0]
      raise 'service does not appear to exist' if @service_stats.empty?
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
      table = Terminal::Table.new headings: ['DEPLOYMENTS', ''], rows: t
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

    def task_family
      # known issue, won't work with / in task family names
      # TODO: improve this later
      @service_stats[0]['task_definition'].split('/')[1].split(':')[0]
    end
    # list task arns for a service
    def tasks
      @client.list_tasks(cluster: @cluster, service_name: @name)[0]
    end
    # list all container instance arns for given service's tasks
    def container_instances
      instances = []
      @client.describe_tasks(cluster: @cluster, tasks: tasks)[0].each do |e|
        instances << e[:container_instance_arn]
      end
      instances
    end
    # return container instance arn for given task id
    def container_instance(task_arn)
    instance = []
    @client.describe_tasks(cluster: @cluster, tasks: [task_arn])[0].each do |e|
      instance << e[:container_instance_arn]
    end
    instance[0]
    end

    def container_instance_id(arn)
      instance = [arn.to_s]
      @client.describe_container_instances(cluster: @cluster, container_instances: instance)[0][0][:ec2_instance_id]
    end

    def container_instance_ids
      ids = []
      @client.describe_container_instances(cluster: @cluster, container_instances: container_instances)[0].each do |e|
        ids << e[:ec2_instance_id]
      end
      ids.uniq
    end

    def container_instance_ip(instance_id)
      id = [instance_id]
      @ec2_client.describe_instances(instance_ids: id)[:reservations][0][:instances][0][:private_ip_address]
    end

    def container_instance_ips
      ips = []
      @ec2_client.describe_instances(instance_ids: container_instance_ids)[:reservations][0][:instances].each do |e|
        ips << e[:private_ip_address]
      end
      ips
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

    def launch_type
      @service_stats[0]['deployments'][0]['launch_type']
    end

    def tasks_table
      t = []
      if launch_type == 'FARGATE'
        tasks.each do |e|
          t << [e]
        end
        table = Terminal::Table.new headings: ['TASK_ID'], rows: t
      else
        tasks.each do |e|
          t << [e, container_instance_id(container_instance(e)),
                container_instance_ip(container_instance_id(container_instance(e)))]
        end
        table = Terminal::Table.new headings: ['TASK_ID', 'INSTANCE_ID', 'IP'], rows: t
      end
      table
    end

    def overview_table
      row1 = []
      row1 << [name, status, running_count, desired_count, pending_count,
               deployment_configuration['maximum_percent'], deployment_configuration['minimum_healthy_percent']]
      table1 = Terminal::Table.new headings: ['NAME', 'STATUS', 'RUNNING COUNT',
                                              'DESIRED COUNT', 'PENDING COUNT',
                                              'MAX HEALTHY', 'MIN HEALTHY'], rows: row1
      table1
    end

    def task_def_table
      row2 = []
      row2 << [task_definition]
      table2 = Terminal::Table.new headings: ['TASK DEFINITION'], rows: row2
      table2
    end

    def list_service
      puts overview_table
      puts task_def_table
      puts deployments
      puts tasks_table
    end
  end
end
