# Use Ubuntu as base image
FROM ubuntu:20.04

# Install required packages
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy the wisecow script
COPY wisecow.sh /app/wisecow.sh

# Make the script executable and fix line endings
RUN chmod +x /app/wisecow.sh && \
    sed -i 's/\r$//' /app/wisecow.sh

# Set working directory
WORKDIR /app

# Add /usr/games to PATH
ENV PATH="/usr/games:${PATH}"

# Expose port 4499
EXPOSE 4499

# Run the application
CMD ["./wisecow.sh"]
