# Base
FROM condaforge/miniforge3

# Add target user
RUN useradd --uid 911 --user-group --shell /bin/bash --create-home abc

RUN apt-get update && \
    # Install prerequisite tools
    apt-get install -y \
      apt-transport-https \
      git \
      nano \
      build-essential \
      libglu1-mesa \
      libpci3 \
      ccache \
      wget && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create build and external data directories
RUN mkdir -p /mantid_src && \
    mkdir -p /mantid_build && \
    mkdir -p /mantid_data && \
    mkdir -p /ccache/tmp

# Set ccache cache location
ENV CCACHE_DIR /ccache/tmp

# Allow mounting source, build, data and ccache directories
VOLUME ["/mantid_src", "/mantid_build", "/mantid_data", "/ccache"]

# Set default working directory to build directory
WORKDIR /mantid_build

# Add entrypoint
ADD entrypoint.sh /entrypoint.sh
ADD entrypoint.sh /home/entrypoint.sh
ADD entrypoint.d/ /etc/entrypoint.d/
ENTRYPOINT ["/entrypoint.sh"]

