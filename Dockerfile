# Use the official Node.js Alpine image as the base image
FROM node:20-slim

# Set the working directory
WORKDIR /usr/src/app

ENV NODE_ENV production

RUN apt-get update && apt-get install wget unzip -y

RUN wget -q -O - 'https://playwright.azureedge.net/builds/chromium/1088/chromium-linux-arm64.zip' && \
  unzip chromium-linux-arm64.zip && \
  rm -f ./chromium-linux-arm64.zip

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV CHROME_PATH=/chrome-linux/chrome
ENV PUPPETEER_EXECUTABLE_PATH=/chrome-linux/chrome

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm ci --only=production --ignore-scripts

# Copy the rest of the source code to the working directory
COPY . .

# Expose the port the API will run on
EXPOSE 3000

# Start the API
CMD ["npm", "start"]