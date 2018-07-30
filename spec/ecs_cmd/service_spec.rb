require 'spec_helper'

RSpec.describe EcsCmd::Service do
  # it 'fails on invalid service' do
  #   expect {
  #     EcsCmd::Service.new('staging','empty', 'us-east-1').list_service
  #   }.to raise_error(RuntimeError, 'service does not appear to exist')
  # end

  it 'gets service arn' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').arn).to eq('arn:aws:ecs:us-east-1:111111111111:service/foo')
  end

  it 'gets service status' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').status).to eq('ACTIVE')
  end

  it 'gets deployments' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').deployments).to_not be nil
  end

  it 'gets deployment configuration' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').deployment_configuration.to_s).to include('maximum_percent=200')
  end

  it 'gets desired count' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').desired_count).to eq(2)
  end

  it 'gets running count' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').running_count).to eq(2)
  end

  it 'gets pending count' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').pending_count).to eq(0)
  end

  it 'gets task definition' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').task_definition).to eq('arn:aws:ecs:us-east-1:111111111111:task-definition/foo:1')
  end

  it 'gets health check grace period' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').health_check_grace_period).to eq(0)
  end

  it 'gets event stream' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').events.to_s).to include('(service foo)has reached a steady state')
  end

  it 'gets service name' do
    expect(EcsCmd::Service.new('staging', 'foo', 'us-east-1').name).to eq('foo')
  end
end