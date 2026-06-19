# Peter Shin (G01073633)
# Dockerfile for hosting website using nginx using ubuntu
FROM ubuntu:24.04
RUN apt-get update \
    && apt-get install -y nginx
COPY index.html /var/www/html
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]