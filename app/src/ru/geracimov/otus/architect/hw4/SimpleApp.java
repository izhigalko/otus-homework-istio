package ru.geracimov.otus.architect.hw4;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.UnknownHostException;
import java.time.LocalDateTime;

public class SimpleApp {
    private static final String LOG_TEMPLATE = "%s - %s:%-10s %s%n";
    public static final String APP_VERSION = System.getenv("APP_VERSION");

    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        server.createContext("/", httpExchange -> {
            log(httpExchange);
            String body = String.format("App %s main page: %s", APP_VERSION, InetAddress.getLocalHost());
            response(httpExchange, "text/html; charset=utf-8", body);
        });
        server.createContext("/health", httpExchange -> {
            log(httpExchange);
            String body = "{\"status\": \"OK\"}";
            response(httpExchange, "application/json; charset=utf-8", body);
        });

        server.start();
        System.out.println("Server started");
    }

    private static void log(HttpExchange httpExchange) throws UnknownHostException {
        System.out.printf(LOG_TEMPLATE,
                LocalDateTime.now(),
                httpExchange.getRequestMethod(),
                httpExchange.getRequestURI().toString(),
                InetAddress.getLocalHost());
    }

    private static void response(HttpExchange httpExchange, String contentType, String body) throws IOException {
        try (OutputStream os = httpExchange.getResponseBody()) {
            httpExchange.getResponseHeaders().add("content-type", contentType);
            byte[] responseBytes = body.getBytes();
            httpExchange.sendResponseHeaders(200, responseBytes.length);
            os.write(responseBytes);
            os.flush();
        }
    }

}
