FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    nmap \
    curl \
    wget \
    git \
    unzip \
    pv \
    assetfinder \
    httprobe \
 && apt clean

# Install pdtm
RUN wget https://github.com/projectdiscovery/pdtm/releases/download/v0.1.3/pdtm_0.1.3_linux_amd64.zip && \
    unzip pdtm_0.1.3_linux_amd64.zip && \
    cp pdtm /usr/local/bin && \
    chmod +x /usr/local/bin/pdtm && \
    rm -rf pdtm pdtm_0.1.3_linux_amd64.zip LICENSE.md README.md && \
    pdtm -ia

# Move installed tools safely
RUN if [ -d /root/.pdtm/go/bin ]; then cp /root/.pdtm/go/bin/* /usr/local/bin || true; fi

# Config
RUN mkdir -p /root/.config/subfinder && \
    wget https://raw.githubusercontent.com/jake741/dd/main/provider-config.yaml \
    -O /root/.config/subfinder/provider-config.yaml

# Recon script
RUN wget https://raw.githubusercontent.com/jake741/dd/main/recon.sh \
    -O /usr/local/bin/recon.sh && \
    chmod +x /usr/local/bin/recon.sh
# Keep container alive + test tool
CMD ["bash", "-c", "recon.sh opera.com && bash"]
