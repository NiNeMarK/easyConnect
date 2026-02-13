# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# คัดลอกเฉพาะไฟล์โปรเจกต์เพื่อทำ Restore (ช่วยให้ Build ครั้งต่อไปเร็วขึ้น)
COPY easyConnect.csproj ./
RUN dotnet restore

# คัดลอกไฟล์ที่เหลือทั้งหมด
COPY . .

# Build โปรเจกต์ออกมาเป็นไฟล์ Release
RUN dotnet publish "easyConnect.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# คัดลอกไฟล์ที่ Build สำเร็จมาจาก Stage แรก
COPY --from=build /app/publish .

# Render.com บังคับใช้พอร์ต 10000 เป็นค่าเริ่มต้น (หรือตามที่ตั้งในหน้าเว็บ)
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# คำสั่งรันแอปพลิเคชัน
ENTRYPOINT ["dotnet", "easyConnect.dll"]
