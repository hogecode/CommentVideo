#!/bin/bash

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Video App OpenAPI Code Generation Setup ===${NC}\n"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker is not installed. Please install Docker and try again.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker is installed${NC}\n"

# Check if Make is installed (optional)
if command -v make &> /dev/null; then
    echo -e "${GREEN}✅ Make is installed${NC}\n"
    HAS_MAKE=true
else
    echo -e "${YELLOW}ℹ️  Make is not installed. You can still use docker-compose directly.${NC}\n"
    HAS_MAKE=false
fi

# Generate codes
echo -e "${BLUE}Generating Go Chi Server code...${NC}"
if [ "$HAS_MAKE" = true ]; then
    make generate-server
else
    docker-compose up openapi-go-chi-server
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Go Chi Server code generated successfully${NC}\n"
else
    echo -e "${YELLOW}⚠️  Go Chi Server code generation failed${NC}\n"
fi

echo -e "${BLUE}Generating React Query TypeScript client code...${NC}"
if [ "$HAS_MAKE" = true ]; then
    make generate-client
else
    docker-compose up openapi-typescript-react-query
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ React Query TypeScript client code generated successfully${NC}\n"
else
    echo -e "${YELLOW}⚠️  React Query TypeScript client code generation failed${NC}\n"
fi

# Install frontend dependencies
echo -e "${BLUE}Installing frontend dependencies...${NC}"
cd frontend
npm install
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Frontend dependencies installed successfully${NC}\n"
else
    echo -e "${YELLOW}⚠️  Frontend dependency installation failed${NC}\n"
    exit 1
fi

cd ..

# Create .env files if not exist
if [ ! -f .env ]; then
    echo -e "${BLUE}Creating .env file...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✅ .env file created${NC}\n"
fi

if [ ! -f frontend/.env.local ]; then
    echo -e "${BLUE}Creating frontend/.env.local file...${NC}"
    echo "NEXT_PUBLIC_API_BASE_URL=http://localhost:8000" > frontend/.env.local
    echo -e "${GREEN}✅ frontend/.env.local file created${NC}\n"
fi

echo -e "${GREEN}=== Setup completed successfully! ===${NC}\n"
echo -e "${BLUE}Next steps:${NC}"
echo "1. Start the development server: npm run dev (in frontend directory)"
echo "2. Review the generated code:"
echo "   - Go Chi Server: server/generated/"
echo "   - React Query hooks: frontend/src/hooks/useVideosQuery.ts"
echo "   - Generated API: frontend/src/generated/"
echo ""
echo -e "${BLUE}For more information, see docs/code-generation.md${NC}"
