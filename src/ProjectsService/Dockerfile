FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["ProjectsService.csproj", "./"]
RUN dotnet restore "./ProjectsService.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ProjectsService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ProjectsService.csproj" -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ProjectsService.dll"]