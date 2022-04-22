# eth-proxy
Simple proxy for ethereum nodes.
The proxy adds Authorization header to all RPC/WS requests (optional).

# Usage

1. Install Docker.
1. Spin up eth-proxy docker container:
    ```
    # RPC_ENDPOINT - RPC endpoint of the node deployed on Chainstack.
    # WS_ENDPOINT - WebSocket endpoint of the node deployed on Chainstack.
    # ENDPOINT - If the WS and RPC endpoints are the same you can use this variable.
    # USERNAME, PASSWORD - [optional] basic auth credentials to access the node deployed on Chainstack.

    # DNS: DNS host.
    # PORT: The proxy will listen to this port.
    # WS: flag in "YES" to enable a /ws endpoint allowing web sockets
    # STATUS_METHOD: node method to check if the node was rate limited or not.
    ```
1. Use proxy to send requests to the node:
    ```
    curl 'http://localhost:8545' -H 'Content-Type: application/json' -d '{"jsonrpc": "2.0","method": "eth_blockNumber","params": [],"id": 83}'
    ```




