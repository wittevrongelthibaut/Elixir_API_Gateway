# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian instead of
# Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/_/debian?tab=tags&page=1&name=bullseye-20220801-slim - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.14.2-erlang-25.1.1-debian-bullseye-20220801-slim
#
ARG ELIXIR_VERSION=1.14.2
ARG OTP_VERSION=25.1.1
ARG DEBIAN_VERSION=bullseye-20220801-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/

# Copy the env sample to env.secret.exs in the app working directory
COPY config/env.example.exs config/env.secret.exs

# replace {RABBITMQ_CONNECTION_STRING} by ENV value which is a env var(RABBITMQ_URI) declared before build time
RUN sed -i 's|{RABBITMQ_CONNECTION_STRING}|'$RABBITMQ_URI'|g' config/env.secret.exs
RUN sed -i 's|{STUDENT_REQUEST_QUEUE}|'$STUDENT_REQUEST_QUEUE'|g' config/env.secret.exs
RUN sed -i 's|{COMPANY_REQUEST_QUEUE}|'$COMPANY_REQUEST_QUEUE'|g' config/env.secret.exs
RUN sed -i 's|{INTERNSHIP_REQUEST_QUEUE}|'$INTERNSHIP_REQUEST_QUEUE'|g' config/env.secret.exs
RUN sed -i 's|{APPLICATION_REQUEST_QUEUE}|'$APPLICATION_REQUEST_QUEUE'|g' config/env.secret.exs
RUN sed -i 's|{TEACHER_REQUEST_QUEUE}|'$TEACHER_REQUEST_QUEUE'|g' config/env.secret.exs
RUN sed -i 's|{MANAGER_REQUEST_QUEUE}|'$MANAGER_REQUEST_QUEUE'|g' config/env.secret.exs
RUN sed -i 's|{CHATMESSAGE_REQUEST_QUEUE}|'$CHATMESSAGE_REQUEST_QUEUE'|g' config/env.secret.exs
RUN sed -i 's|{CATEGORY_REQUEST_QUEUE}|'$CATEGORY_REQUEST_QUEUE'|g' config/env.secret.exs


RUN mix deps.compile

COPY priv priv

COPY lib lib

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/



RUN ls -l
RUN ls config/





RUN cat config/env.secret.exs

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/api_gateway ./

USER nobody

CMD ["/app/bin/server"]
