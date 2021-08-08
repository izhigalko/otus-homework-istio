FROM rust:1.53-slim-buster as builder
WORKDIR /app
COPY ./app .
RUN cargo build --release

FROM debian:buster-slim
COPY --from=builder /app/target/release/app /app
EXPOSE 8080
CMD ["./app"]