require 'spec_helper'

RSpec.describe EcsCmd::Clusters do
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