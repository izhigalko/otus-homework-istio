import java.io.IOException;
import java.io.OutputStream;
import java.io.*;
import java.net.InetSocketAddress;
import java.util.*;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

public class App {
    static String appVersion = null;

    public static void main(String[] args) throws Exception {
        appVersion = args[0];
        System.out.println("Started");
        HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);
        server.createContext("/traffic", new MyHandler());
        server.setExecutor(null); // creates a default executor
        server.start();
    }


    static class MyHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            System.out.println("Request accepted");
            String response = "{\"status\": \"OK\"}, \"version\": \"" + appVersion + "\"}";
            t.sendResponseHeaders(200, response.length());
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }


}