FROM kalilinux/kali-rolling

# Install basic tools
RUN apt update && apt install -y \
    nmap \
    curl \
    wget \
    git \
    && apt clean

# Keep container alive + test tool
CMD ["bash", "-c", "echo 'Kali container started'; ifconfig"]
