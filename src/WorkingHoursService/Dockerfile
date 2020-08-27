FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["WorkingHoursService.csproj", "./"]
RUN dotnet restore "./WorkingHoursService.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "WorkingHoursService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WorkingHoursService.csproj" -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WorkingHoursService.dll"]