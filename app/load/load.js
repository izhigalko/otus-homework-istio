import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '5m', target: 50 },
        { duration: '1m', target: 60 },
        { duration: '1m', target: 20 },
        { duration: '1m', target: 30 },
        { duration: '1m', target: 10 },
        { duration: '1m', target: 0 },
    ]
};

export default () => {
    http.get(`http://hw5-service.default/`);
    sleep(1)
};