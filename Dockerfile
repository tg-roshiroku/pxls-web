# Frontend Dockerfile for pxls-web
FROM node:20-alpine

# Install git (required for GitHub dependencies)
RUN apk add --no-cache git curl

# Test network connectivity and DNS resolution
RUN curl -I https://codeload.github.com/ || echo "GitHub connectivity test failed"

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Configure git to use HTTPS instead of SSH for GitHub
RUN git config --global url."https://github.com/".insteadOf "git@github.com:"

# Configure npm to use alternative registry or settings if needed
RUN npm config set registry https://registry.npmjs.org/

# Try to install dependencies with retries and alternative approaches
RUN npm install --verbose || \
   (echo "First attempt failed, trying with different settings..." && \
   npm config set fetch-retry-mintimeout 20000 && \
   npm config set fetch-retry-maxtimeout 120000 && \
   npm config set fetch-retries 5 && \
   npm install) || \
   (echo "Second attempt failed, trying without package-lock..." && \
   rm -f package-lock.json && \
   npm install)

# Copy source code
COPY . .

# Create config from example if it doesn't exist
RUN if [ ! -f config.json5 ]; then cp config.example.json5 config.json5; fi

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
