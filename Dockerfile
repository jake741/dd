FROM kalilinux/kali-rolling
# Install pdtm
RUN apt update && apt install -y \
    nmap \
    curl \
    wget \
    assetfinder || true && \
    apt install -y httprobe || true && \
    apt install -y pv git unzip && \
    apt clean && \
    wget https://github.com/projectdiscovery/pdtm/releases/download/v0.1.3/pdtm_0.1.3_linux_amd64.zip && \
    unzip pdtm_0.1.3_linux_amd64.zip && \
    cp pdtm /usr/local/bin && \
    chmod +x /usr/local/bin/pdtm && \
    rm -rf pdtm pdtm_0.1.3_linux_amd64.zip LICENSE.md README.md && \
    pdtm -ia && \
    mkdir -p /root/.pdtm/go/bin && \
    cp /root/.pdtm/go/bin/* /usr/local/bin 2>/dev/null || true && \
    mkdir -p /root/.config/subfinder && \
    wget https://raw.githubusercontent.com/jake741/dd/main/provider-config.yaml -O /root/.config/subfinder/provider-config.yaml && \
    wget https://raw.githubusercontent.com/jake741/dd/main/recon.sh -O /usr/local/bin/recon.sh && \
    chmod +x /usr/local/bin/recon.sh \
    recon.sh opera.com
# Don't run recon.sh in the Dockerfile - run it separately
    
    
# Keep container alive + test tool
CMD ["bash", "-c", "echo 'Kali container started'; nmap --version; sleep infinity"]
