import http from 'k6/http';
import { check, sleep } from 'k6';

const KUBE_HOST = "127.0.0.1";

export default function() {
    const res = http.get(`http://${KUBE_HOST}/hello`);
    check(res, { 'status was 200': (r) => r.status == 200 });
    sleep(1);
}