# Frontend Dockerfile for pxls-web
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Create config from example if it doesn't exist
RUN if [ ! -f config.json5 ]; then cp config.example.json5 config.json5; fi

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
