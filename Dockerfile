# Stage 1: Build the application
FROM elixir:1.17.3-alpine AS build

# Install build dependencies
RUN apk add --no-cache build-base nodejs npm git gcc bash openssl

# Set environment variables for UTF-8 encoding
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

# Set environment variables for Phoenix
ENV MIX_ENV=prod
ENV PORT=4000
ENV PHX_SERVER=true

# Install Hex and Rebar
RUN mix local.hex --force && mix local.rebar --force

# Create and set the working directory
WORKDIR /app

# Cache Elixir dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy the entire project
COPY . .

# Compile assets (if any)
RUN mix assets.deploy

# Compile the project
RUN mix compile

# Generate the release
RUN mix release

# Stage 2: Release the application
FROM alpine:3.18 AS app

# Install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs

# Set environment variables for UTF-8 encoding
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

# Set environment variables for Phoenix
ENV MIX_ENV=prod
ENV PORT=4000
ENV PHX_SERVER=true

# Set the working directory
WORKDIR /app

# Copy the release from the build stage
COPY --from=build /app/_build/prod/rel/guitar_and_bass_exchange ./

# Expose the port Phoenix runs on
EXPOSE 4000

# Start the Phoenix server
CMD ["bin/guitar_and_bass_exchange", "start"]
