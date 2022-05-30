FROM rubensa/ubuntu-tini-dev-chrome
LABEL author="Ruben Suarez <rubensa@gmail.com>"

# Architecture component of TARGETPLATFORM (platform of the build result)
ARG TARGETARCH

# Tell docker that all future commands should be run as root
USER root

# Set root home directory
ENV HOME=/root

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt
RUN apt-get update

# Install kdiff3
RUN echo "# Installing kdiff3..." \
    && if [ "$TARGETARCH" = "arm64" ]; then \
        # Referenced qtbase-abi-5-15-2 package is a dummy tansitional package (to libqt5core5a) that is not available so we need to fake it
        apt-get -y install --no-install-recommends equivs 2>&1 \
        && printf "Section: misc\nPriority: optional\nStandards-Version: 3.9.2\nPackage: qtbase-abi-5-15-2\nDescription: Dummy package" > qtbase-abi-5-15-2 \
        && equivs-build qtbase-abi-5-15-2 \
        && dpkg -i qtbase-abi-5-15-2_1.0_all.deb; \
    fi \
    && apt-get -y install --no-install-recommends kdiff3 2>&1

# Clean up apt
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

# Tell docker that all future commands should be run as the non-root user
USER ${USER_NAME}

# Set user home directory (see: https://github.com/microsoft/vscode-remote-release/issues/852)
ENV HOME /home/$USER_NAME
