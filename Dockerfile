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
    rm -rf pdtm* LICENSE.md README.md && \
    pdtm -ia

# Move tools
RUN if [ -d /root/.pdtm/go/bin ]; then cp /root/.pdtm/go/bin/* /usr/local/bin || true; fi

# Config
RUN mkdir -p /root/.config/subfinder && \
    wget https://raw.githubusercontent.com/jake741/dd/main/provider-config.yaml \
    -O /root/.config/subfinder/provider-config.yaml

# Scripts
RUN wget https://raw.githubusercontent.com/jake741/dd/main/recon.sh \
    -O /usr/local/bin/recon.sh && chmod +x /usr/local/bin/recon.sh

RUN wget https://raw.githubusercontent.com/jake741/dd/main/automate.sh \
    -O /usr/local/bin/automate.sh && chmod +x /usr/local/bin/automate.sh

# ✅ FIXED PATH
RUN wget https://raw.githubusercontent.com/jake741/dd/main/wildcard.txt \
    -O /root/wildcard.txt

# 🔥 DEBUG + SAFE EXECUTION
CMD ["bash", "-c", "\
echo '[+] start_tool'; \
echo '[+] checking file'; \
ls -l /root/wildcard.txt; \
echo '[+] preview:'; \
head /root/wildcard.txt; \
echo '[+] running script'; \
cat /root/wildcard.txt | /usr/local/bin/automate.sh || echo '[!] pipeline failed'; \
echo '[+] done'; \
sleep infinity"]
