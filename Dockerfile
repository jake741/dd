FROM kalilinux/kali-rolling

# Install basic tools
RUN apt update && apt install -y \
    nmap \
    curl \
    wget \
    git \
    unzip \
    && apt clean
RUN wget https://github.com/projectdiscovery/pdtm/releases/download/v0.1.3/pdtm_0.1.3_linux_amd64.zip && unzip pdtm_0.1.3_linux_amd64.zip && ./qdtm
# Keep container alive + test tool
CMD ["bash", "-c", "echo 'Kali container started'; nmap --version; sleep infinity"]
