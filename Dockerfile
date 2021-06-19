##### build container #####
FROM rust:1.50.0 as builder

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/app/target \
    cargo install --path .


##### run container #####
# FROM rust:1.50.0-slim-buster
# FROM debian:buster-slim
# https://github.com/GoogleContainerTools/distroless/blob/master/base/README.md
# FROM gcr.io/distroless/base-debian10 ==> do not work...
FROM gcr.io/distroless/cc

COPY --from=builder /usr/local/cargo/bin/rust-app ./

CMD ["./rust-app"]
