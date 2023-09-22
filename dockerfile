# Use the official .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the .csproj and .sln files to the container
COPY *.csproj .
COPY *.sln .

# Restore NuGet packages
RUN dotnet restore

# Copy the rest of the application code to the container
COPY . .

# Build the application
RUN dotnet publish -c Release -o out

# Create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime

# Set the working directory in the runtime image
WORKDIR /app

# Copy the published application from the build image to the runtime image
COPY --from=build /app/out .

# Specify the command to run your application
CMD ["dotnet", "YourApp.dll"]
