# ใช้ภาพพื้นฐานเป็น Debian ที่มีเครื่องมือสำหรับ Compile ภาษา C
FROM debian:bullseye-slim

# ติดตั้งตัวช่วย Compile (gcc, make) และ Library ที่จำเป็น (เช่น openssl)
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# ตั้งโฟลเดอร์ทำงาน
WORKDIR /app

# คัดลอกไฟล์ทั้งหมดใน Repo เข้าไปใน Container
COPY . .

# สั่ง Compile โปรเจกต์ผ่าน Makefile (ถ้ามี) หรือสั่ง gcc ตรงๆ
# ในกรณีนี้ Repo นี้ใช้ Makefile ให้รัน:
RUN make

# ระบุคำสั่งที่ให้รันตอน Start (เปลี่ยน 'easyconnect' เป็นชื่อไฟล์ที่ได้หลัง build)
# หมายเหตุ: คุณต้องเช็ก options ในโปรแกรมด้วยว่าต้องใส่พอร์ตหรือ config อะไรไหม
CMD ["./easyconnect"]
