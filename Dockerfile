#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
#COPY ["CM.WeeklyTeamReport.WebAPI.csproj", "src/CM.WeeklyTeamReport.WebAPI/"]
COPY ["src/CM.WeeklyTeamReport.WebAPI/CM.WeeklyTeamReport.WebAPI.csproj", "src/CM.WeeklyTeamReport.WebAPI/"]
RUN dotnet restore "src/CM.WeeklyTeamReport.WebAPI/CM.WeeklyTeamReport.WebAPI.csproj"
COPY . .
WORKDIR "/src/src/CM.WeeklyTeamReport.WebAPI"
RUN dotnet build "CM.WeeklyTeamReport.WebAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CM.WeeklyTeamReport.WebAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CM.WeeklyTeamReport.WebAPI.dll"]