.PHONY: help build up down logs clean test backend-test frontend-test backend-build frontend-build

help:
	@echo "Available commands:"
	@echo "  make build           - Build all Docker images"
	@echo "  make up              - Start all services"
	@echo "  make down            - Stop all services"
	@echo "  make logs            - View logs from all services"
	@echo "  make clean           - Remove all containers, volumes, and images"
	@echo "  make test            - Run all tests"
	@echo "  make backend-test    - Run backend tests"
	@echo "  make frontend-test   - Run frontend tests"
	@echo "  make backend-build   - Build backend"
	@echo "  make frontend-build  - Build frontend"
	@echo "  make dev-db          - Start only PostgreSQL for development"

build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

clean:
	docker-compose down -v --rmi all

test: backend-test frontend-test

backend-test:
	cd backend && ./gradlew test

frontend-test:
	cd frontend && npm test

backend-build:
	cd backend && ./gradlew build

frontend-build:
	cd frontend && npm run build

dev-db:
	docker-compose -f docker-compose.dev.yml up -d

dev-db-down:
	docker-compose -f docker-compose.dev.yml down

# Terraform commands
tf-init:
	cd terraform && terraform init

tf-plan:
	cd terraform && terraform plan

tf-apply:
	cd terraform && terraform apply

tf-destroy:
	cd terraform && terraform destroy

# Azure deployment commands
azure-login:
	az login

azure-build-push-backend:
	cd backend && docker build -t $(ACR_NAME).azurecr.io/backend:latest .
	docker push $(ACR_NAME).azurecr.io/backend:latest

azure-build-push-frontend:
	cd frontend && docker build -t $(ACR_NAME).azurecr.io/frontend:latest .
	docker push $(ACR_NAME).azurecr.io/frontend:latest
