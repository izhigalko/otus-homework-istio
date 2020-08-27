FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["TasksService.csproj", "./"]
RUN dotnet restore "./TasksService.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "TasksService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TasksService.csproj" -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TasksService.dll"]