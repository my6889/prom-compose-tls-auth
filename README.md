# 快速部署带有基础认证和SSL加密的Prometheus生态监控组件

## 准备环境

* Docker
* Docker-compose
* htpasswd命令
* Ubuntu 20.04及以上


---

## 快速开始
**安装htpasswd命令**
```
apt-get install apache2-utils -y
```


**生成证书和设置密码**
```
bash set-password.sh
```
用户名已固定为`admin`，按提示输入密码即可，同时会生成有效期20年的证书。**只需执行一次即可!**
运行命令后，会自动把密码的明文填入到`prometheus.yml`文件中，会自动把密文填入`web-auth.yml`配置文件中。


**（选做）**
1.修改alertmanager.yml，设置发件邮箱等配置
2.在prometheus/rules中修改或添加告警规则配置
3.在prometheus.yml中添加被监控实例

**启动Prometheus生态服务**

```
docker-compose up -d 
```
启动的组件包含Prometheus、Alertmanager、Grafana、Blackbox_exporter, 其中Grafana没有额外配置SSL和基础认证。

**访问服务**

```
http://宿主机IP:3000     # Grafana
https://宿主机IP:9090    # Prometheus
https://宿主机IP:9093    # Alertmanager
https://宿主机IP:9115    # Blackbox_exporter
```

<font color=#FF0000 >**完全移除**</font> 

```
# 慎重操作
docker-compose down -v 
rm -r prom-compose
```

**安装启动Node_exporter**
必要前提：如果启用SSL和基础认证，必须先执行“生成证书和设置密码”步骤！
```
cd node-exporter
bash install_node_exporter.sh
```
如果需要在其它多台服务器上安装Node_exporter，可以直接把node-exporter目录复制到其它服务器，然后执行`bash install_node_exporter.sh`即可。

