FROM langflowai/langflow:latest
RUN mkdir /app/flows
COPY ./*.json /app/flows/
ENV LANGFLOW_LOAD_FLOWS_PATH=/app/flows

# Set default PostgreSQL connection environment variables
ENV POSTGRES_HOST=localhost
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=newtest

# Create a startup script to configure MCP server with dynamic PostgreSQL connection
RUN echo '#!/bin/bash\n\
# Set default values if not provided\n\
POSTGRES_HOST=${POSTGRES_HOST:-localhost}\n\
POSTGRES_PORT=${POSTGRES_PORT:-5432}\n\
POSTGRES_USER=${POSTGRES_USER:-postgres}\n\
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-mypassword}\n\
POSTGRES_DB=${POSTGRES_DB:-postgres}\n\
\n\
# Configure MCP server with PostgreSQL connection\n\
if [ -n "$POSTGRES_HOST" ] && [ -n "$POSTGRES_USER" ] && [ -n "$POSTGRES_PASSWORD" ] && [ -n "$POSTGRES_DB" ]; then\n\
    export DATABASE_URL="postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"\n\
    echo "✅ MCP Server configured with PostgreSQL connection:"\n\
    echo "   Host: $POSTGRES_HOST:$POSTGRES_PORT"\n\
    echo "   Database: $POSTGRES_DB"\n\
    echo "   User: $POSTGRES_USER"\n\
    echo "   DATABASE_URL: $DATABASE_URL"\n\
else\n\
    echo "⚠️  Warning: PostgreSQL environment variables not fully configured"\n\
    echo "   Please set: POSTGRES_HOST, POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB"\n\
fi\n\
\n\
# Start Langflow\n\
echo "🚀 Starting Langflow..."\n\
exec langflow run "$@"' > /app/start.sh && chmod +x /app/start.sh

# Override the default entrypoint
ENTRYPOINT ["/app/start.sh"]
