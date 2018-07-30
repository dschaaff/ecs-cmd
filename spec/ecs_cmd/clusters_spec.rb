require 'spec_helper'

RSpec.describe EcsCmd::Clusters do
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
  it 'gets clusters' do
    expect(EcsCmd::Clusters.new('us-east-1').get_clusters['cluster_arns']).to include('arn:aws:ecs:us-east-1:111111111111:cluster/staging')
  end

  # it 'get_container_instance_count' do
  #   expect(EcsCmd::Clusters.new('us-east-1').get_container_instance_count).to eq 5
  # end

  it 'lists clusters' do
    expect(EcsCmd::Clusters.new('us-east-1').cluster_names).to include('arn:aws:ecs:us-east-1:111111111111:cluster/staging')
  end
end