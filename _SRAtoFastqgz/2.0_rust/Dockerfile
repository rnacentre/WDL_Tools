FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    pigz \
    && rm -rf /var/lib/apt/lists/* \
    && pigz --version

# 复制 Rust 脚本到 /root 目录
COPY rustSra2gz /root/rustSra2gz

# 给予 Rust 脚本执行权限
RUN chmod +755 /root/rustSra2gz

# 设置工作目录
WORKDIR /root

# 默认执行 Rust 脚本（根据需要调整）
# ENTRYPOINT ["/root/rustSra2gz"]
