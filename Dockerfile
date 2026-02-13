# Step 1: ใช้ .NET 8.0 SDK เป็น Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Step 2: ติดตั้งเครื่องมือสำหรับ Compile ภาษา C (gcc, make)
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Step 3: คัดลอกไฟล์จาก Repo เข้าไป
COPY . .

# Step 4: สั่ง Compile ตัวโปรแกรมภาษา C (easyConnect)
# หมายเหตุ: ตรวจสอบว่าใน Repo มีไฟล์ Makefile หรือไม่ 
# ถ้าไม่มีอาจต้องสั่ง gcc -o easyconnect easyconnect.c
RUN make || gcc -o easyconnect easyconnect.c -lssl -lcrypto

# Step 5: (ตัวเลือก) ถ้าคุณมีโปรเจกต์ .NET อยู่ด้วย ให้ Build ตรงนี้
# RUN dotnet publish -c Release -o out

# Step 6: ใช้ .NET 8.0 Runtime สำหรับการรันจริง
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/easyconnect .

# ระบุคำสั่งรัน (สมมติว่าตัวโปรแกรมชื่อ easyconnect)
ENTRYPOINT ["./easyconnect"]
