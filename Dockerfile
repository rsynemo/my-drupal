FROM bitnami/drupal:latest

# 切换到root用户以获得足够的权限
USER root

# 创建.vscode-server目录并设置相应的权限
RUN mkdir -p /.vscode-server && chmod -R 777 /.vscode-server

# 切换回原始用户（Bitnami镜像中通常是1001）
USER 1001
