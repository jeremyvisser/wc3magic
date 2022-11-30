# TWC3 Interface

The TWC3 uses a protocol buffer based API at endpoint `/tedapi/v1`, which
the web interface uses for configuration.

Using protobuf standard tooling, you can automate the configuration.

What's included:

- `wc3.proto`: a protocol buffer definition compatible with the TWC3 configuration interface
- `send.sh`: a utility that wraps `protoc` and `curl` for sending a request
- `set-charge-current.sh`: a utility that sets the max output current
- `examples/*.textproto`: sample requests and responses
