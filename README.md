# Langflow Custom Container with Dynamic PostgreSQL MCP Integration

This Docker container provides a pre-configured Langflow instance with:
- **Default Flow**: `view (1).json` - A comprehensive database assistant flow with MCP Tools integration
- **Dynamic PostgreSQL Connection**: Fully configurable via environment variables
- **MCP Server Integration**: Automatic PostgreSQL MCP server configuration that adapts to any PostgreSQL setup
- **Universal Compatibility**: Works on any laptop with any PostgreSQL configuration

## Quick Start

### Basic Usage (with existing PostgreSQL container)
```bash
docker run -d -p 7860:7860 \
  --network your-postgres-network \
  -e POSTGRES_HOST=your-postgres-container \
  -e POSTGRES_PORT=5432 \
  -e POSTGRES_USER=your-username \
  -e POSTGRES_PASSWORD=your-password \
  -e POSTGRES_DB=your-database \
  --name langflow-custom \
  duncan3/langflow-custom:1.2.0
```

### With External PostgreSQL Database
```bash
docker run -d -p 7860:7860 \
  -e POSTGRES_HOST=your-postgres-host.com \
  -e POSTGRES_PORT=5432 \
  -e POSTGRES_USER=your-username \
  -e POSTGRES_PASSWORD=your-password \
  -e POSTGRES_DB=your-database \
  --name langflow-custom \
  duncan3/langflow-custom:1.2.0
```

### With Docker Compose
```yaml
version: '3.8'
services:
  langflow:
    image: duncan3/langflow-custom:1.2.0
    ports:
      - "7860:7860"
    environment:
      - POSTGRES_HOST=postgres
      - POSTGRES_PORT=5432
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=mypassword
      - POSTGRES_DB=newtest
    depends_on:
      - postgres
    networks:
      - langflow-network

  postgres:
    image: postgres:15
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=mypassword
      - POSTGRES_DB=newtest
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - langflow-network

networks:
  langflow-network:
    driver: bridge

volumes:
  postgres_data:
```

## Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `POSTGRES_HOST` | PostgreSQL server hostname | `localhost` | Yes |
| `POSTGRES_PORT` | PostgreSQL server port | `5432` | Yes |
| `POSTGRES_USER` | PostgreSQL username | `postgres` | Yes |
| `POSTGRES_PASSWORD` | PostgreSQL password | `mypassword` | Yes |
| `POSTGRES_DB` | PostgreSQL database name | `newtest` | Yes |

## Features

### Default Flow: `view (1).json`
The container includes a pre-configured flow with:
- **Chat Input/Output**: Interactive chat interface
- **Agent Component**: Database assistant with PostgreSQL expertise
- **MCP Tools**: PostgreSQL query execution capabilities
- **OpenRouter Integration**: AI model for natural language processing

### MCP Server Integration
- Automatic PostgreSQL MCP server configuration
- Dynamic connection string generation
- Real-time database query capabilities
- Schema exploration and data analysis

### Flow Components
1. **Chat Input**: User message input
2. **Agent**: Database assistant with PostgreSQL knowledge
3. **MCP Tools**: PostgreSQL query execution
4. **OpenRouter**: AI language model
5. **Chat Output**: Response display

## Usage Examples

### Access the Web Interface
Once running, access Langflow at: `http://localhost:7860`

### Example Queries
- "What tables are in the database?"
- "Show me the schema of the users table"
- "How many records are in the products table?"
- "What are the relationships between tables?"

## Troubleshooting

### Connection Issues
1. **Verify PostgreSQL is accessible**:
   ```bash
   docker exec langflow-custom-v2 python -c "import psycopg2; conn = psycopg2.connect(host='your-host', port=5432, user='your-user', password='your-password', database='your-db'); print('Connected!'); conn.close()"
   ```

2. **Check environment variables**:
   ```bash
   docker exec langflow-custom-v2 env | grep POSTGRES
   ```

3. **Verify network connectivity**:
   ```bash
   docker exec langflow-custom-v2 ping -c 2 your-postgres-host
   ```

### MCP Server Issues
- Ensure PostgreSQL credentials are correct
- Verify the database exists and is accessible
- Check that the MCP server can connect to the database

## Security Notes

- **Never expose PostgreSQL credentials** in logs or environment files
- **Use Docker secrets** for production deployments
- **Restrict network access** to PostgreSQL containers
- **Use strong passwords** for database connections

## Version History

- **v1.2.0**: **Dynamic MCP Configuration** - Removed hardcoded values, fully configurable via environment variables
- **v1.1.0**: Added dynamic PostgreSQL configuration and `view (1).json` flow
- **v1.0.0**: Initial release with basic Langflow setup

## What's New in v1.2.0

### ✅ **Universal Compatibility**
- **No hardcoded values**: The flow no longer contains hardcoded PostgreSQL connection details
- **Dynamic MCP configuration**: MCP server automatically uses environment variables
- **Works on any laptop**: Just provide your PostgreSQL connection details via environment variables

### ✅ **Improved Startup Process**
- **Clear configuration feedback**: Shows exactly what PostgreSQL connection is being used
- **Default values**: Provides sensible defaults if environment variables are not set
- **Better error handling**: Clear warnings if configuration is incomplete

### ✅ **Example Startup Output**
```
✅ MCP Server configured with PostgreSQL connection:
   Host: host.docker.internal:5432
   Database: postgres
   User: postgres
   DATABASE_URL: postgresql://postgres:mypassword@host.docker.internal:5432/postgres
🚀 Starting Langflow...
```

## Support

For issues or questions:
1. Check the container logs: `docker logs langflow-custom-v2`
2. Verify your PostgreSQL connection parameters
3. Ensure all required environment variables are set
