# crossbar_server
crossbar router and client

# create debug_crossbar image
docker build -f .\Dockerfile.dockerfile -t debug_crossbar .


# Steps to create guest node, and start debug_crossbar
1. Clone the below repo
https://github.com/crossbario/crossbar-examples

2. Goto below path and update config.json with guest_node_config.json
- \crossbar-examples\hello\java\.crossbar\config.json

3. Clone guestnode project (You can choose guest/worker node thats written in python)
- ##TBD (will share this project)
- clone it (/guestnode_path)

4. Run the image debug_crossbar
- docker run -v /guestnode_path:/workspace -v  C:/Users/<>/crossbar-examples/hello/java:/node -u 0 --name=crossbar_java  -d -p 8080:8080 -p 6003:8090   debug_crossbar:latest



#Following files can help for admin dashboards
crossbar-examples/getting-started/2.pubsub-js/backend.html
crossbar-examples/getting-started/2.pubsub-js/client.html

