# Frontend Dockerfile for pxls-web
FROM node:20-alpine

# Install git (required for GitHub dependencies)
RUN apk add --no-cache git

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Configure git to use HTTPS instead of SSH for GitHub
RUN git config --global url."https://github.com/".insteadOf "git@github.com:"

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Create config from example if it doesn't exist
RUN if [ ! -f config.json5 ]; then cp config.example.json5 config.json5; fi

# Build the application (creates dist directory)
RUN npm run build

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
