# Base image
FROM python:3.9-slim

# Çalışma dizinini belirle
WORKDIR /app

# Gerekli dosyaları kopyala
COPY requirements.txt .
COPY app.py .

# Uygulama bağımlılıklarını yükle
RUN pip install --no-cache-dir -r requirements.txt

# Uygulama çalıştırma komutu
CMD [ "python", "app.py" ]
