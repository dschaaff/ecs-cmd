RSpec.describe EcsCmd do
  Aws.config[:ecs] = {
    stub_responses: {
      list_clusters: {
        cluster_arns:
          ['arn:aws:ecs:us-east-1:111111111111:cluster/staging']
      },
      describe_clusters: {
        clusters: [
          cluster_arn: 'arn:aws:ecs:us-east-1:111111111111:cluster/staging',
          cluster_name: 'staging',
          status: 'ACTIVE',
          registered_container_instances_count: 5,
          running_tasks_count: 20,
          pending_tasks_count: 1,
          active_services_count: 6
        ]
      },
      describe_services: {
        services: [
          {
            service_arn: 'arn:aws:ecs:us-east-1:111111111111:service/foo',
            service_name: 'foo',
            status: 'ACTIVE',
            desired_count: 2,
            running_count: 2,
            pending_count: 0,
            health_check_grace_period_seconds: 0,
            task_definition:   'arn:aws:ecs:us-east-1:111111111111:task-definition/foo:1',
            deployment_configuration: {
              maximum_percent: 200,
              minimum_healthy_percent: 100
            },
            events: [
              {
                id: '1234',
                created_at: Time.new('2018-06-15 07:50:46 -0700'),
                message: '(service foo)has reached a steady state'
              }
            ],
            deployments: [
              {
                id: 'ecs-svc/9223370507780529222',
                status: 'primary',
                task_definition:   'arn:aws:ecs:us-east-1:111111111111:task-definition/foo:1',
                desired_count: 2,
                pending_count: 0,
                running_count: 2,
                created_at: Time.new('2018-06-15 07:50:46 -0700'),
                updated_at: Time.new('2018-06-15 07:51:46 -0700'),
                launch_type: 'EC2'
              }
            ]
          },
          {
            service_arn: 'arn:aws:ecs:us-east-1:111111111111:service/empty',
            service_name: 'foo'
          }
        ]
      }
    }
  }
  it 'has a version number' do
    expect(EcsCmd::VERSION).not_to be nil
  end
end
