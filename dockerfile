FROM alpine:latest AS build

RUN apk add --no-cache dotnet7-sdk && \
    mkdir /app
COPY src /app
WORKDIR /app
RUN dotnet build -o /app/output

FROM alpine:latest AS runtime
RUN apk add --no-cache aspnetcore7-runtime && \
    mkdir /app
COPY --from=build /app/output /app
WORKDIR /app
RUN addgroup -S app_group && \
    adduser -S app_user -G app_group && \
    chown -R app_user:app_group /app
USER app_user
ENTRYPOINT [ "./dotnet", "--urls", "http://0.0.0.0:5000" ]
EXPOSE 5000