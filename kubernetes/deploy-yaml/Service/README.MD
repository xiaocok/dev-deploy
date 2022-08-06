## Services

[TOC]



### 什么是Service

Service是为一组Pod提供入口调度服务，并可以在Pod之间实现负载均衡。由于Pod是有生命周期的，每当Pod进行销毁而启动时IP地址也会随之改变，这将无法被调用者发现到，而Service出新就是为了解决服务发现这个问题，提供一个稳定的入口已便于服务调用者，而不用去关心Pod的IP地址变化。



### 什么是EndPoint

Service会根据资源定义清单中的选择器选择与之绑定的Pod成员，EndPoint就是存储这些Pod成员的IP及端口信息。







### 参考

- [Kubernetes - 5.1 Discovery and Load Balancing - Service](https://www.toutiao.com/i6799992711689536004)

