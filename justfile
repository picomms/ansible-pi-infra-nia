# Ansible Pi infra — common workflows
# Run `just` or `just --list` to see available recipes.

playbook := "system-provision.yml"
uv := "uv run"
secrets := "-e @vault/secrets.yml"

# Show available recipes
default:
    @just --list

# Install Python deps and Galaxy roles/collections
install:
    uv sync
    {{uv}} ansible-galaxy install -r requirements.yml

# Run all static checks
validate: syntax lint inventory

# Check playbook YAML and Ansible syntax
syntax:
    {{uv}} ansible-playbook {{playbook}} --syntax-check

# Lint playbooks and tasks
lint:
    {{uv}} ansible-lint

# Show resolved inventory
inventory:
    {{uv}} ansible-inventory --graph

# List tasks that would run
list-tasks:
    {{uv}} ansible-playbook {{playbook}} --list-tasks

# Ping hosts (default: all)
ping host="all":
    {{uv}} ansible {{host}} -m ping {{secrets}}

# Dry-run playbook (default: all hosts)
check host="all":
    {{uv}} ansible-playbook {{playbook}} --check --diff --limit {{host}}

# Apply playbook (default: all hosts)
provision host="all":
    {{uv}} ansible-playbook {{playbook}} --limit {{host}}

# Apply only Docker-tagged tasks
provision-docker host="docker":
    {{uv}} ansible-playbook {{playbook}} --limit {{host}} --tags docker

# Edit encrypted vault secrets
vault-edit:
    {{uv}} ansible-vault edit vault/secrets.yml

# View encrypted vault secrets
vault-view:
    {{uv}} ansible-vault view vault/secrets.yml

vault-encrypt:
    {{uv}} ansible-vault encrypt vault/secrets.yml

vault-decrypt:
    {{uv}} ansible-vault decrypt vault/secrets.yml
