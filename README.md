# Ecs-Cmd

[![Build Status](https://travis-ci.org/dschaaff/ecs-cmd.svg?branch=master)](https://travis-ci.org/dschaaff/ecs-cmd) [![Gem Version](https://badge.fury.io/rb/ecs_cmd.svg)](https://badge.fury.io/rb/ecs_cmd)

This is a command line application for interacting with AWS ECS. The standard AWS cli can be a bit
cumbersome for some tasks. Ecs-cmd aims to simplify those tasks.

## Installation

```bash
gem install ecs_cmd
```

The gem uses the standard aws crendential chain for authentication actions. See https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html for reference.

## Usage

```
ecs-cmd
NAME
    ecs-cmd - Command utility for interacting with AWS ECS

SYNOPSIS
    ecs-cmd [global options] command [command options] [arguments...]

VERSION
    0.1.3

GLOBAL OPTIONS
    --help              - Show this message
    -r, --region=region - Set the aws region (default: us-east-1)
    --version           - Display the program version

COMMANDS
    exec     - Execute a Command Within a Service's Container
    get      - Get Info on Clusters and Services
    help     - Shows a list of commands or help for one command
    logs     - Tail Logs From a Service's Container
    run-task - Run a One Off Task On an ECS Cluster
    shell    - Open a Shell Inside a Service's Container
    ssh      - SSH into Host Task is Running On
```

### Get Commands

These allow you to query information from ECS.

#### Get Clusters

```
 ecs-cmd get clusters
+--------------------+--------------------------+----------+---------------+---------------+
| CLUSTER NAME       | CONTAINER_INSTANCE_COUNT | SERVICES | RUNNING_TASKS | PENDING_TASKS |
+--------------------+--------------------------+----------+---------------+---------------+
| production         | 20                       | 39       | 82            | 0             |
| development        | 1                        | 2        | 1             | 0             |
+--------------------+--------------------------+----------+---------------+---------------+
```

#### Get Services

Prints an overview of the services in a given cluster.

```shella
ecs-cmd get services --help
NAME
    services -

SYNOPSIS
    ecs-cmd [global options] get services [command options]

COMMAND OPTIONS
    -c, --cluster=cluster - cluster name (required, default: none)
```

```shell
ecs-cmd get services -c testing
+--------------------+---------------+---------------+---------------+
| SERVICE NAME       | DESIRED_COUNT | RUNNING_COUNT | PENDING_COUNT |
+--------------------+---------------+---------------+---------------+
| datadog-agent      | 1             | 0             | 0             |
| foo-bar            | 1             | 1             | 0             |
+--------------------+---------------+---------------+---------------+
```

#### Get Service

Get information on a specific service in a cluster.

```shell
cs-cmd get service --help
NAME
    service -

SYNOPSIS
    ecs-cmd [global options] get service [command options]

COMMAND OPTIONS
    -c, --cluster=cluster      - cluster name (required, default: none)
    -e, --[no-]events          - get ecs events
    -s, --service=service      - service name (required, default: none)
    -t, --[no-]task_definition - get current task definition for service
```

```shell
ecs-cmd get service -c production -s foo
+------+--------+---------------+---------------+---------------+-------------+-------------+
| NAME | STATUS | RUNNING COUNT | DESIRED COUNT | PENDING COUNT | MAX HEALTHY | MIN HEALTHY |
+------+--------+---------------+---------------+---------------+-------------+-------------+
| foo  | ACTIVE | 2             | 2             | 0             | 200         | 50          |
+------+--------+---------------+---------------+---------------+-------------+-------------+
+----------------------------------------------------------------------+
| TASK DEFINITION                                                      |
+----------------------------------------------------------------------+
| arn:aws:ecs:us-east-1:xxxxxxxxxxxx:task-definition/foo-production:25 |
+----------------------------------------------------------------------+
+---------------------+--------------+
| INSTANCE ID         | IP           |
+---------------------+--------------+
| i-xxxxxxxxxxxxxxxxx | 10.0.230.1   |
| i-xxxxxxxxxxxxxxxxx | 10.0.220.3   |
+---------------------+--------------+
+-----------------+----------------------------------------------------------------------+
| DEPLOYMENTS     |                                                                      |
+-----------------+----------------------------------------------------------------------+
| id              | ecs-svc/xxxxxxxxxxxxxxxxxxx                                          |
| status          | PRIMARY                                                              |
| task definition | arn:aws:ecs:us-east-1:xxxxxxxxxxxx:task-definition/foo-production:25 |
| desired count   | 2                                                                    |
| pending count   | 0                                                                    |
| running count   | 2                                                                    |
| created at      | 2018-12-07 09:44:59 -0800                                            |
| updated at      | 2018-12-07 09:45:58 -0800                                            |

+-----------------+----------------------------------------------------------------------+
```

### Logs

**_works for ec2 type services only_**

**_requires ssh access to instance_**

Streams logs from 1 of a services running tasks using the docker logs command

```shell
ecs-cmd logs --help
NAME
    logs - Tail Logs From a Service's Container

SYNOPSIS
    ecs-cmd [global options] logs [command options]

COMMAND OPTIONS
    -c, --cluster=cluster - cluster name (required, default: none)
    -l, --lines=lines     - number of historical lines to tail (default: 30)
    -s, --service=service - service name (required, default: none)
```

### Run Task

Run a one off task in ECS. This will poll for the task to exit and report its exit code. This is
handy for tasks like rails migrations in ci/cd pipelines. If a docker image is passed it will create a new revision of 
the task definition prior to running the task.

```shell
ecs-cmd run-task --help
NAME
    run-task - Run a One Off Task On an ECS Cluster

SYNOPSIS
    ecs-cmd [global options] run-task [command options]

COMMAND OPTIONS
    -c, --cluster=cluster               - cluster name (required, default: none)
    -d, --command=command               - override task definition command (default: none)
    -i, --image=image                   - docker image to use for task (default: none)
    -n, --container-name=container name - container name (default: none)
    -t, --task-definition=arg           - the task definition to use for task (required, default: none)
```

### Shell

**_works for ec2 type services only_**

**_requires ssh access to instance_**

Open a shell inside of a container for a given service.

```shell
ecs-cmd shell --help
NAME
    shell - Open a Shell Inside a Service's Container

SYNOPSIS
    ecs-cmd [global options] shell [command options]

COMMAND OPTIONS
    -c, --cluster=cluster - cluster name (required, default: none)
    -s, --service=service - service name (required, default: none)
    --[no-]sh             - use sh instead of bash
    -u, --user=user       - user name or uid (default: root)
```

### SSH

**_works for ec2 type services only_**

**_requires ssh access to instance_**

SSH onto a host where a container for a given service is running.

```shell
ecs-cmd ssh --help
NAME
    ssh - SSH into Host Task is Running On

SYNOPSIS
    ecs-cmd [global options] ssh [command options]

COMMAND OPTIONS
    -c, --cluster=cluster - cluster name (required, default: none)
    -s, --service=service - service name (required, default: none)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ecs_cmd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EcsCmd project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ecs_cmd/blob/master/CODE_OF_CONDUCT.md).
