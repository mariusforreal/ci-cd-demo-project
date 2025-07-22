# Use official Node.js LTS base image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Expose the app port (should match your app.js)
EXPOSE 3000

# Start the app
CMD ["npm", "start"]

