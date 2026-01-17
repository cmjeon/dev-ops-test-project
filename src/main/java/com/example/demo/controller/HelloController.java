package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @Value("${my-env}")
    private String myEnv;

    @GetMapping("/")
    public String home() {
        return "hello world 60 try 만에 성공! current env: " + myEnv;
    }

}
