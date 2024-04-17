FROM gcr.io/cloud-builders/gcloud

# Set environment variables
ENV YQ_VERSION=4.43.1
ENV DOCKER_VERSION=5:24.0.9-1~ubuntu.20.04~focal
ENV GRADLE_VERSION=8.7

# Install some helpful utilities
RUN apt-get update && apt-get install -y \
    unzip \
    wget \
    gnupg2 \
    jq \
    software-properties-common

# Install yq
RUN curl -sL https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -o /usr/bin/yq && chmod +x /usr/bin/yq

# Install git
RUN apt-get update && apt-get install -y git

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install -y \
    docker-ce=${DOCKER_VERSION} \
    docker-ce-cli=${DOCKER_VERSION} \
    containerd.io \
    docker-compose-plugin

# Install Bats
RUN git clone https://github.com/bats-core/bats-core.git && \
    cd bats-core && \
    ./install.sh /usr/local

# Install node 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# Clean up APT
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./scripts /scripts
RUN chmod +x /scripts -R

ENV PATH="/scripts:${PATH}"

COPY ./dockerfiles /dockerfiles

USER 0:0

# Set the entrypoint to /bin/bash
ENTRYPOINT ["/bin/bash"]

