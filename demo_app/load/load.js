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
/*
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST=$(minikube ip)
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "http://$GATEWAY_URL/"
результат укзать ниже
 */
export default () => {
    http.get(`http://192.168.49.2:31414/`);
    sleep(1)
};