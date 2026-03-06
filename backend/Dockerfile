# Dockerfile for SYNAPSE Backend
FROM node:20-slim

WORKDIR /app

# Install system dependencies if needed (e.g. for sqlite3 build)
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy package files
COPY package*.json ./

# Install npm dependencies
RUN npm install --production

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Start command
CMD ["npm", "start"]
