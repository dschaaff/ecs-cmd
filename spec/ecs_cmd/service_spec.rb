require 'spec_helper'

RSpec.describe EcsCmd::Service do
  it 'fails on invalid service' do
    Aws.config[:ecs] = {
        stub_responses: {
        }
      }
    expect {
      EcsCmd::Service.new('production','foo', 'us-east-1').list_service
    }.to raise_error(RuntimeError, 'service does not appear to exist')
  end
end