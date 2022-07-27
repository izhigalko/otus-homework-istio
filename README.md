# Практика к занятию по теме "Service mesh на примере Istio"

## Задачи

Задание состоит из этапов

- Развернуть Istio c Ingress gateway
- Развернуть две версии приложения с использованием Istio
- Настроить балансировку трафика между версиями приложения на уровне Gateway 50% на 50%
- Сделать снимок экрана с картой сервисов в Kiali с примеров вызова двух версии сервиса

![Пример карты сервисов с балансировкой трафика между версиями](kiali.png)


colima version

    colima version 0.4.4
    git commit: 8bb1101a861a8b6d2ef6e16aca97a835f65c4f8f
    
    runtime: docker
    arch: aarch64
    client: v20.10.12
    server: v20.10.11
    
    kubernetes
    Client Version: v1.23.6
    Server Version: v1.23.6+k3s1

istioctl version   

    client version: 1.14.1
    control plane version: 1.14.1
    data plane version: 1.14.1 (6 proxies)

kubectl version

    Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.6", 
        GitCommit:"ad3338546da947756e8a88aa6822e9c11e7eac22", GitTreeState:"clean", 
        BuildDate:"2022-04-14T08:41:58Z", GoVersion:"go1.18.1", Compiler:"gc", Platform:"darwin/arm64"}
    Server Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.6+k3s1",
        GitCommit:"418c3fa858b69b12b9cefbcff0526f666a6236b9", GitTreeState:"clean",
        BuildDate:"2022-04-28T22:16:58Z", GoVersion:"go1.17.5", Compiler:"gc", Platform:"linux/arm64"}

