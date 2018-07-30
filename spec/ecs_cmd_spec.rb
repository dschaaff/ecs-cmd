RSpec.describe EcsCmd do
  it 'has a version number' do
    expect(EcsCmd::VERSION).not_to be nil
  end

  it 'fails on invalid service' do
    expect {
      EcsCmd::Service.new('production','foo', 'us-east-1').list_service
    }.to raise_error(RuntimeError, 'service does not appear to exist')
  end

  it 'gets clusters' do
    Aws.config[:ecs] = {
        stub_responses: {
          list_clusters: { cluster_arns: ['arn:aws:ecs:us-east-1:111111111111:cluster/staging'] }
        }
      }
    expect(EcsCmd::Clusters.new('us-east-1').get_clusters['cluster_arns']).to include('arn:aws:ecs:us-east-1:111111111111:cluster/staging')
  end
  it 'lists clusters' do
    Aws.config[:ecs] = {
        stub_responses: {
          list_clusters: { cluster_arns: ['arn:aws:ecs:us-east-1:111111111111:cluster/staging'] },
          describe_clusters: { clusters: [
            cluster_arn: 'arn:aws:ecs:us-east-1:111111111111:cluster/staging',
            cluster_name: 'staging',
            status: 'ACTIVE',
            registered_container_instances_count: 5,
            running_tasks_count: 20,
            pending_tasks_count: 1,
            active_services_count: 6
            ]}
        }
      }
    expect(EcsCmd::Clusters.new('us-east-1').cluster_names).to include('arn:aws:ecs:us-east-1:111111111111:cluster/staging')
  end
end
