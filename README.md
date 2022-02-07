# OpenSPA-docker
* Git repo of the unofficial docker image for [OpenSPA](https://github.com/greenstatic/openspa)
* OpenSPA images help you to follow [OpenSPA official tutorial](https://github.com/greenstatic/openspa/blob/master/docs/OpenSPA%20Server%20Installation%20with%20iptables.md) easily

# How  to pull from Docker hub
    docker pull sepaper/openspa-server
    docker pull sepaper/openspa-client
# How to build
1. Clone openspa-docker repo and initialize submodules
    ```bash
    git clone https://github.com/sepaper/openspa-docker.git
    
    cd openspa-docker
    git submodule init --update
    
    cd openspa
    go mod init github.com/greenstatic/openspa
    go mod tidy
    ```
2. Run build-server.sh to build OpenSPA server
    ```bash
    # To build for Linux (amd64) explicitly
    ./build-server.sh linux amd64 openspa-server 1.0.0
    
    # To build for MacOS (arm64) explicitly 
    ./build-server.sh darwin arm64 openspa-server 1.0.0
    ```
3. Run build-client.sh to build OpenSPA client
    ```bash
    # To build for Linux (amd64) explicitly
    ./build-client.sh linux amd64 openspa-client 1.0.0
    
    # To build for MacOS (arm64) explicitly 
    ./build-cient.sh darwin arm64 openspa-client 1.0.0
    ```
    
# How to run for the tutorial
1. Run echo ipv4 server in host
    ```bash
    # In host
    docker run --name echoip -d greenstatic/echo-ip # this server returns an echo response like {"success":true,"ip":"172.17.0.3","isIpv6":false,"datetime":"2022-02-02T08:23:15Z","ipDetails":{"remoteIP":"172.17.0.3","forwardedForIP":""},"service":"echo-ip","version":"1.2.0","srcUrl":"https://github.com/greenstatic/echo-ip"}
    ```
2. Check the built images
    ```bash
    # In host
    docker images
    ```
3. Create directories used by OpenSPA server to store server key pair and client public keys
    ```bash
    # In host
    mkdir server
    mkdir server/server-keys
    mkdir server/client-keys # used for user(client) directory service
    ```
4. Create a directory used by OpenSPA client to store client public key and config
   ```bash
    # In host
    mkdir clients
    ```
5. Copy OpenSPA server public key to the clients directory
   ```bash
    # In host
    cp server/server-keys/server.pub clients/.
    ```
6. Generate OpenSPA server key pair using OpenSSL
    ```bash
    # In host
    openssl genrsa -out server/server-keys/server.key 2048
    openssl rsa -in server/server-keys/server.key -outform PEM -pubout -out server/server-keys/server.pub
    ```
7. Run OpenSPA server
   ```bash
    # In host
    # NET_ADMIN capability is necessary to set iptables
    docker run --name openspa-server --cap-add=NET_ADMIN -v $(pwd)/server/server-keys:/openspa/keys -v $(pwd)/server/client-keys:/openspa/es/public_keys openspa-server:1.0.0 --echo-ipv4-server http://<echo ipv4 server ip>:<port>

8. Run OpenSPA client
    ```bash
    # In host
    docker run --name openspa-client -v $(pwd)/clients:/openspa/clients -it openspa-client:1.0.0 /bin/bash
    ```
9. Generate client key pair and config using OpenSPA tools
    ```bash
    # In host
    docker exec -it openspa-client /bin/bash
    # In OpenSPA client
    cd openspa
    ./openspa-tools gen-client clients/pub -o clients # you can press enter for all to set as default
    ls clients # find out client device id in a name of created directory
    ```
10. Register OpenSPA client public key to OpenSPA server
    ```bash
    # In host
    cp clients/0195e956-....-ef2er/0195e956-....-ef2er.pub server/client-keys/.
    ```
11. Send OpenSPA request and ping to OpenSPA server in OpenSPA client
    ```bash
    # In OpenSPA client
    ./openspa-client request clients/0195e956-....-ef2er/client.ospa --protocol icmp -p 1 --echo-ipv4-server http://<echo ipv4 server ip>:<port> --server-ip <OpenSPA server ip>
    ping <OpenSPA server ip>
    ```
