FROM loadimpact/k6

# minikube ip
ENV GATEWAY_HOST ...

# kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}'
ENV GATEWAY_PORT ...

COPY load.js /
CMD ["run", "/load.js"]
