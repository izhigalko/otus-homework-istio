package com.architect.api.debug.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class DtoHealthCheckResponse {
    private final String status;
}
