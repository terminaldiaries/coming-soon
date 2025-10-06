# Use a lightweight Nginx image as the base
FROM nginx:stable-alpine-slim

# Copy your static website files to the Nginx default document root
COPY . /usr/share/nginx/html

# Expose port 80, which is the default for Nginx
EXPOSE 80

# Command to run Nginx when the container starts (default for Nginx image)
CMD ["nginx", "-g", "daemon off;" ]
