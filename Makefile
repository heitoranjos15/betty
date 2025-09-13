.PHONY: build up down logs shell migrate makemigrations superuser clean 

build:
	@echo "Building Docker images..."
	docker-compose -f betty_scout/docker-compose.yml build
	docker-compose -f betty_memory/docker-compose.yml build
	docker-compose -f betty_admin/docker-compose.yml build

up:
	@echo "Starting Docker services..."
	docker-compose -f betty_scout/docker-compose.yml up -d
	docker-compose -f betty_memory/docker-compose.yml up -d
	docker-compose -f betty_admin/docker-compose.yml up -d

down:
	@echo "Stopping Docker services..."
	docker-compose -f betty_scout/docker-compose.yml down
	docker-compose -f betty_memory/docker-compose.yml down
	docker-compose -f betty_admin/docker-compose.yml down

