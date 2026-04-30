FROM kalilinux/kali-rolling

# Install basic tools
RUN apt update && apt install -y \
    nmap \
    curl \
    wget \
    assetfinder \
    httprobe \
    pv \
    git \
    unzip \
    && apt clean

# Install pdtm
RUN wget https://github.com/projectdiscovery/pdtm/releases/download/v0.1.3/pdtm_0.1.3_linux_amd64.zip && \
    unzip pdtm_0.1.3_linux_amd64.zip && \
    cp pdtm /usr/local/bin && \
    chmod +x /usr/local/bin/pdtm && \
    rm -rf pdtm pdtm_0.1.3_linux_amd64.zip LICENSE.md README.md && \
    pdtm -ia && \
    cp /root/.pdtm/go/bin/* /usr/local/bin && \
    mkdir -p /root/.config/subfinder && \
    wget https://raw.githubusercontent.com/jake741/dd/main/provider-config.yaml && \
    mv provider-config.yaml /root/.config/subfinder/ && \
    wget https://raw.githubusercontent.com/jake741/dd/main/recon.sh && \
    chmod +x recon.sh && \
    cp recon.sh /usr/local/bin/ && \
    recon.sh opera.com
    
    
# Keep container alive + test tool
CMD ["bash", "-c", "echo 'Kali container started'; nmap --version; sleep infinity"]
