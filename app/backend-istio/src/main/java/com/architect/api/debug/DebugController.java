package com.architect.api.debug;

import com.architect.api.debug.dto.response.DtoHealthCheckResponse;
import io.prometheus.client.CollectorRegistry;
import io.prometheus.client.Counter;
import io.prometheus.client.Histogram;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class DebugController {

    private static final int VERSION = 2;

    private final Counter requestCount;
    private final Histogram requestLatency;

    private final RestTemplate restTemplate;

    public DebugController(CollectorRegistry collectorRegistry, RestTemplateBuilder restTemplateBuilder) {
        requestCount = Counter.build()
                .name("request_count")
                .help("Total number of requests")
                .register(collectorRegistry);

        requestLatency = Histogram.build()
                .name("request_duration")
                .help("Request latency in seconds")
                .register(collectorRegistry);
        this.restTemplate = restTemplateBuilder.build();
    }

    @GetMapping("/health")
    public DtoHealthCheckResponse healthCheck() {
        return DtoHealthCheckResponse.builder()
                .status("OK")
                .build();
    }

    @GetMapping("/version")
    public String version() {
        return String.format("Version: %d", VERSION);
    }

    @GetMapping("/metrics")
    public String metrics() {
        requestCount.inc();

        Histogram.Timer requestTimer = requestLatency.startTimer();
        try {
            return "Metrics";
        } finally {
            requestTimer.observeDuration();
        }
    }

    @GetMapping
    public ResponseEntity<?> fetchEchoServerResult(@RequestParam(required = false) String url) {
        if (url == null) {
            return ResponseEntity.ok("Empty result");
        }

        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setContentType(MediaType.TEXT_PLAIN);
        String result = restTemplate.getForObject(url, String.class);
        return new ResponseEntity<>(result, httpHeaders, HttpStatus.OK);
    }
}
