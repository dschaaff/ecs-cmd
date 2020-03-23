# Next

# 0.2.0

- add --sudo flag to enable running docker commands with sudo, defaults to true
- Combine shell and exec commands. Pass a shell like `sh` or `bash` to interactively login to a container.

# 0.1.7

- bugfix: Run task did not work when task definition contained secrets.
- bugfix: Failed to parse image name for images from docker hub (e.g. redis:alpine)

# 0.1.6

- bugfix: remove pry require

# 0.1.4

- Added user flag to shell command. `ecs-cmd shell -c production -s foo -u nobody`
- Added user flag to exec command. `ecs-cmd exec -c production -s foo -u nobody whoami`