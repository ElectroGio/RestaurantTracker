
# Base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

EXPOSE 80
EXPOSE 443
EXPOSE 4003
EXPOSE 5003
EXPOSE 8080


# SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia los archivos de proyecto al contenedor
COPY ["./AspisConsulting.Wizzatrip.Application/AspisConsulting.Wizzatrip.Application.csproj", "src/AspisConsulting.Wizzatrip.Application/"]
COPY ["./AspisConsulting.Wizzatrip.Domain/AspisConsulting.Wizzatrip.Domain.csproj", "src/AspisConsulting.Wizzatrip.Domain/"]
COPY ["./AspisConsulting.Wizzatrip.Web/AspisConsulting.Wizzatrip.Web.csproj", "src/AspisConsulting.Wizzatrip.Web/"]
COPY ["./AspisConsulting.Wizzatrip.Infrastructure/AspisConsulting.Wizzatrip.Infrastructure.csproj", "src/AspisConsulting.Wizzatrip.Infrastructure/"]



# Restaura las dependencias del proyecto
RUN dotnet restore "src/AspisConsulting.Wizzatrip.Web/AspisConsulting.Wizzatrip.Web.csproj"


# Copia el resto de los archivos al contenedor
COPY . .

# Compila los proyectos
WORKDIR "/src/AspisConsulting.Wizzatrip.Web/"
RUN dotnet build -c Release -o /app/build


# Publica los proyectos
FROM build AS publish

RUN dotnet publish -c Release -o /app/publish

FROM base AS runtime

WORKDIR /app
COPY --from=publish /app/publish .
RUN ls -l

ENTRYPOINT ["dotnet", "/app/AspisConsulting.Wizzatrip.Web.dll"]