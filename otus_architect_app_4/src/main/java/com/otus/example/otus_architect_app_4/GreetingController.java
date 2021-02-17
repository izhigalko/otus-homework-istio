package com.otus.example.otus_architect_app_4;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class GreetingController {

  @Value("${version}")
  private String version;

  @RequestMapping(value = "/health", method = RequestMethod.GET)
  @ResponseBody
  public String greeting() {
    return "{\"status\": \"OK\", \"version\"=\"" + version + "\"}";
  }

}