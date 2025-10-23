# Demo Application - Spring Boot + Next.js + PostgreSQL

A full-stack application demonstrating modern web development with Spring Boot backend, Next.js frontend, and PostgreSQL database, ready for deployment on Azure using Terraform.

## Technology Stack

### Backend
- **Framework**: Spring Boot 3.2.0
- **Language**: Java 17
- **Build Tool**: Gradle 8.5
- **Database**: PostgreSQL 16
- **ORM**: Spring Data JPA with Hibernate
- **Migration**: Flyway
- **API Style**: RESTful

### Frontend
- **Framework**: Next.js 14 with App Router
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **UI**: React 18

### Infrastructure
- **Containerization**: Docker & Docker Compose
- **Cloud Provider**: Microsoft Azure
- **IaC Tool**: Terraform
- **Database**: Azure Database for PostgreSQL Flexible Server
- **Hosting**: Azure App Service (Linux)
- **Registry**: Azure Container Registry

## Project Structure

```
.
├── backend/                    # Spring Boot application
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/example/demo/
│   │   │   │   ├── config/          # Configuration classes
│   │   │   │   ├── controller/      # REST controllers
│   │   │   │   ├── model/           # Entity models
│   │   │   │   ├── repository/      # Data repositories
│   │   │   │   ├── service/         # Business logic
│   │   │   │   └── DemoApplication.java
│   │   │   └── resources/
│   │   │       ├── application.yml
│   │   │       ├── application-dev.yml
│   │   │       ├── application-prod.yml
│   │   │       └── db/migration/    # Flyway migrations
│   │   └── test/
│   ├── build.gradle
│   ├── settings.gradle
│   └── Dockerfile
│
├── frontend/                   # Next.js application
│   ├── src/
│   │   ├── app/
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx
│   │   │   └── globals.css
│   │   ├── components/
│   │   └── lib/
│   ├── public/
│   ├── package.json
│   ├── tsconfig.json
│   ├── tailwind.config.ts
│   ├── next.config.js
│   └── Dockerfile
│
├── terraform/                  # Infrastructure as Code
│   ├── modules/
│   │   ├── networking/         # VNet, Subnets, NSG
│   │   ├── database/           # PostgreSQL Flexible Server
│   │   ├── app-service/        # Azure App Services
│   │   └── container-registry/ # Azure Container Registry
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
│
├── docker-compose.yml          # Full stack orchestration
├── docker-compose.dev.yml      # Development database
└── README.md
```

## Getting Started

### Prerequisites

- **Java 17** or higher
- **Node.js 20** or higher
- **Docker** and **Docker Compose**
- **Terraform** 1.0+ (for Azure deployment)
- **Azure CLI** (for Azure deployment)

### Local Development

#### 1. Start PostgreSQL Database

```bash
# Start only the database for development
docker-compose -f docker-compose.dev.yml up -d
```

#### 2. Run Backend

```bash
cd backend

# Using Gradle wrapper
./gradlew bootRun

# Or build and run
./gradlew build
java -jar build/libs/*.jar
```

The backend will be available at `http://localhost:8080`

#### 3. Run Frontend

```bash
cd frontend

# Install dependencies
npm install

# Copy environment file
cp .env.local.example .env.local

# Start development server
npm run dev
```

The frontend will be available at `http://localhost:3000`

### Running with Docker Compose

Build and run the entire stack:

```bash
# Build and start all services
docker-compose up --build

# Run in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

Services:
- Frontend: http://localhost:3000
- Backend: http://localhost:8080
- PostgreSQL: localhost:5432

## API Documentation

### Health Check Endpoint

```
GET /api/health
```

Response:
```json
{
  "status": "UP",
  "message": "Application is running"
}
```

## Database Migrations

Database migrations are managed by Flyway. Migration files are located in:
```
backend/src/main/resources/db/migration/
```

Migrations run automatically on application startup.

## Azure Deployment with Terraform

### Prerequisites

1. Install Azure CLI and login:
```bash
az login
```

2. Create a Service Principal (if needed):
```bash
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

3. Set environment variables:
```bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<subscription_id>"
export ARM_TENANT_ID="<tenant>"
```

### Deploy Infrastructure

1. Navigate to terraform directory:
```bash
cd terraform
```

2. Initialize Terraform:
```bash
terraform init
```

3. Create a `terraform.tfvars` file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set your values:
```hcl
project_name      = "demo-app"
environment       = "dev"
location          = "eastus"
db_admin_password = "YourSecurePassword123!"
```

4. Plan the deployment:
```bash
terraform plan
```

5. Apply the configuration:
```bash
terraform apply
```

6. Note the outputs:
```bash
terraform output
```

### Build and Push Docker Images

1. Login to Azure Container Registry:
```bash
az acr login --name <acr-name>
```

2. Build and push backend:
```bash
cd backend
docker build -t <acr-name>.azurecr.io/backend:latest .
docker push <acr-name>.azurecr.io/backend:latest
```

3. Build and push frontend:
```bash
cd frontend
docker build -t <acr-name>.azurecr.io/frontend:latest .
docker push <acr-name>.azurecr.io/frontend:latest
```

4. Restart App Services to pull new images:
```bash
az webapp restart --name <backend-app-name> --resource-group <resource-group>
az webapp restart --name <frontend-app-name> --resource-group <resource-group>
```

## Environment Variables

### Backend
- `SPRING_PROFILES_ACTIVE`: Active profile (dev/prod)
- `DB_HOST`: Database host
- `DB_PORT`: Database port (default: 5432)
- `DB_NAME`: Database name
- `DB_USERNAME`: Database username
- `DB_PASSWORD`: Database password
- `SERVER_PORT`: Server port (default: 8080)

### Frontend
- `NEXT_PUBLIC_API_URL`: Backend API URL

## Configuration

### Backend Configuration

Configuration files are located in `backend/src/main/resources/`:
- `application.yml`: Base configuration
- `application-dev.yml`: Development overrides
- `application-prod.yml`: Production overrides

### Frontend Configuration

Configuration in `frontend/next.config.js` for Next.js settings and API proxy.

## Testing

### Backend Tests
```bash
cd backend
./gradlew test
```

### Frontend Tests
```bash
cd frontend
npm test
```

## Monitoring

Azure App Service provides built-in monitoring:
- Application Insights (optional)
- Log Stream
- Metrics

Access via Azure Portal or Azure CLI:
```bash
az webapp log tail --name <app-name> --resource-group <resource-group>
```

## Security Best Practices

1. **Secrets Management**: Use Azure Key Vault for production secrets
2. **Database**: PostgreSQL is in a private VNet
3. **HTTPS**: All App Services enforce HTTPS
4. **Authentication**: Implement proper authentication (consider Azure AD)
5. **CORS**: Configure appropriate CORS policies

## Troubleshooting

### Backend not starting
- Check database connection
- Verify environment variables
- Check logs: `docker-compose logs backend`

### Frontend can't connect to backend
- Verify `NEXT_PUBLIC_API_URL` is set correctly
- Check CORS configuration in backend
- Ensure backend is running and healthy

### Database connection issues
- Verify PostgreSQL is running: `docker-compose ps`
- Check credentials in environment variables
- Ensure database migrations completed successfully

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Support

For issues and questions:
- Open an issue in the repository
- Check existing documentation
- Review Azure documentation for deployment issues
