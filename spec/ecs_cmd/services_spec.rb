require 'spec_helper'

RSpec.describe EcsCmd::Services do

  it 'lists services' do
      Aws.config[:ecs] = {
    stub_responses: {
      list_clusters: {
        cluster_arns:
          ['arn:aws:ecs:us-east-1:111111111111:cluster/staging']
      },
      list_services: {
        service_arns: [
          'arn:aws:ecs:us-east-1:111111111111:service/foo',
          'arn:aws:ecs:us-east-1:111111111111:service/bar',
          'arn:aws:ecs:us-east-1:111111111111:service/staging/baz'
        ]
      }
    }
  }
    expect(EcsCmd::Services.new('us-east-1', 'staging').get_services).to eq([
      'arn:aws:ecs:us-east-1:111111111111:service/foo', 'arn:aws:ecs:us-east-1:111111111111:service/bar', 'arn:aws:ecs:us-east-1:111111111111:service/staging/baz'
    ])
  end
end