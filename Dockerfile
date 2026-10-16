# ========================================================
# Dockerfile - ES TEH SOLO (Java 21 & Embedded Tomcat)
# Cocok untuk Railway, Render, Fly.io, Koyeb, atau VPS Docker
# ========================================================

FROM maven:3.9.9-eclipse-temurin-21
WORKDIR /app

# 1. Download dependency terlebih dahulu (caching layer)
COPY pom.xml .
RUN mvn dependency:resolve -B

# 2. Salin kode sumber dan aset database
COPY src ./src
COPY database ./database

# 3. Kompilasi aplikasi
RUN mvn compile -DskipTests

# 4. Port default (otomatis membaca env PORT jika di cloud)
ENV PORT=8080
EXPOSE 8080

# 5. Jalankan server embedded
CMD ["mvn", "exec:java"]
