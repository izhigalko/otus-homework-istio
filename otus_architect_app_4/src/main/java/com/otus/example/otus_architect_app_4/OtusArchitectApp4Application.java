package com.otus.example.otus_architect_app_4;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class OtusArchitectApp4Application {

  public static void main(String[] args) throws IOException {
    SpringApplication application = new SpringApplication(OtusArchitectApp4Application.class);

    System.out.println("Work dir: " + new File(".").getAbsolutePath());

    Properties properties = new Properties();
    properties.load(new FileInputStream("./config/application.properties"));
    application.setDefaultProperties(properties);

    System.out.println("Properties loaded: " + properties);

    application.run(args);
  }

}
