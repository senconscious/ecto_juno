# Set elixir version
FROM elixir:1.14

# Set test environment
ENV MIX_ENV=test

# Install hex and rebar for deps
RUN mix local.hex --force
RUN mix local.rebar --force

# Create app context
WORKDIR /app

# Copy deps files
COPY mix.exs mix.lock /app

# Get and compile deps
RUN mix deps.get
RUN mix deps.compile

# Copy linters and formatter files
COPY .credo.exs .dialyzer_ignore.exs .formatter.exs /app

# Copy ecto_juno's code
COPY lib /app/lib
COPY test /app/test

# Compile ecto_juno
RUN mix compile

# Entrypoint
CMD mix check