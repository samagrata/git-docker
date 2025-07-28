# Use the latest Alpine Linux as the base image
FROM alpine:latest

# Define a build argument for the SSH key email
ARG SSH_EMAIL="default@example.com"

# Inatll bash
RUN apk update && apk add bash

# Install git and openssh-client (which includes ssh-agent)
# --no-cache flag reduces image size by not caching package indexes
RUN apk add --no-cache git openssh-client

# Create the .ssh directory with appropriate permissions for the root user
# This is necessary before generating SSH keys
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Generate an SSH key pair using the Ed25519 algorithm, as recommended by GitHub.
# -t ed25519 specifies the Ed25519 algorithm.
# -C "${SSH_EMAIL}" adds a comment to the key, using the build argument.
# -f /root/.ssh/id_ed25519 specifies the output file for the private key.
# -N "" sets an empty passphrase for the key (for automation, consider security implications).
# -q makes the key generation quiet.
RUN ssh-keygen -t ed25519 -C "${SSH_EMAIL}" -f /root/.ssh/id_ed25519 -N "" -q

# Start the ssh-agent and add the newly generated private key to it
# eval "$(ssh-agent -s)" starts the agent and sets its environment variables
# ssh-add adds the private key to the agent. Note the updated key file name.
RUN eval "$(ssh-agent -s)" && \
    ssh-add /root/.ssh/id_ed25519

# Display the public SSH key to the console
# This will be printed during the image build process
RUN echo "--- Public SSH Key ---" && \
    cat /root/.ssh/id_ed25519.pub && \
    echo "----------------------"

# Set the default command to run when the container starts
# This will keep the container running and provide a shell prompt
CMD ["bash"]
