# .NET SDK görüntüsünü kullanarak uygulamayı derle
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Bağımlılıkları kopyala ve geri yükle
COPY *.csproj ./
RUN dotnet restore

# Tüm dosyaları kopyala ve derleme yap
COPY . ./
RUN dotnet publish -c Release -o /out

# Çalıştırılabilir ortamı oluştur
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /out .
EXPOSE 8080
ENTRYPOINT ["dotnet", "Web.dll"]