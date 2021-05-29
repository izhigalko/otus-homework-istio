import { check, sleep } from 'k6';
import http from 'k6/http';
export default function () {
  var r = http.get(__ENV.GATEWAY_URL);
  check(r, {
    'status is 200': (r) => r.status === 200,
  });
  sleep(.5);
}