FROM kalilinux/kali-rolling

# Install basic tools
RUN apt update && apt install -y \
    nmap \
    curl \
    wget \
    git \
    unzip \
    && apt clean

# Install pdtm
RUN wget https://github.com/projectdiscovery/pdtm/releases/download/v0.1.3/pdtm_0.1.3_linux_amd64.zip && \
    unzip pdtm_0.1.3_linux_amd64.zip && \
    cp pdtm /usr/local/bin && \
    chmod +x /usr/local/bin/pdtm && \
    rm -rf pdtm pdtm_0.1.3_linux_amd64.zip \
    rm LICENSE.md README.md \
    cp ~/.pdtm/go/bin/* /usr/local/bin

# Install all PD tools
RUN pdtm -ia

# Keep container alive + test tool
CMD ["bash", "-c", "echo 'Kali container started'; nmap --version; sleep infinity"]
