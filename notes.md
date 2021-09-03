Refer Deepbox

/home/giri37/wamp/crossbar_server


# build crossbar_server image
docker build -t debug_crossbar .

root@sathish-linux-deep:/home/giri37/wamp/crossbar_server# docker images
REPOSITORY                                        TAG                           IMAGE ID       CREATED              SIZE
debug_crossbar                                    latest                        4c84d4b8a32a   About a minute ago   529MB <--------------
hub.hertzai.com/debug_crossbar                    latest                        049ae485e471   29 minutes ago       529MB
hevolve-db-app                                    oct25                         47920f182b37   2 weeks ago          381MB

# Run the server
docker run -v /home/giri37/crossbar-examples/hello/java/:/node -u 0 --name=crossbar_server -d -p 8082:8080 -p 6003:8090   debug_crossbar:latest
root@sathish-linux-deep:/home/giri37/wamp/crossbar_server# docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED         STATUS         PORTS                                                      NAMES
6d939ff3df27   debug_crossbar:latest   "crossbar start --cb…"   6 seconds ago   Up 5 seconds   8000/tcp, 0.0.0.0:8082->8080/tcp, 0.0.0.0:6003->8090/tcp   crossbar_server
da80b58ec87e   hevolve-db-app:oct25    "uvicorn app.main:co…"   2 weeks ago     Up 2 weeks                                                                hevolve_db_app
root@sathish-linux-deep:/home/giri37/wamp/crossbar_server# 

# Test the server is running 
root@sathish-linux-deep:/home/giri37/wamp/crossbar_server# curl 0.0.0.0:8082
<!DOCTYPE html>
<html>
   <body>
      <h1>Hello WAMP</h1>
      <p>Open JavaScript console to watch output.</p>
      <script>AUTOBAHN_DEBUG = false;</script>
      <script src="/shared/autobahn/autobahn.min.js"></script>

      <script>
         // the URL of the WAMP Router (Crossbar.io)
         //
         var wsuri;
         if (document.location.origin == "file://") {
            wsuri = "ws://127.0.0.1:8080/ws";

         } else {
            wsuri = (document.location.protocol === "http:" ? "ws:" : "wss:") + "//" +
                        document.location.host + "/ws";
         }


         // the WAMP connection to the Router
         //
         var connection = new autobahn.Connection({
            url: wsuri,
            realm: "realm1"
         });


         // timers
         //
         var t1, t2;


         // fired when connection is established and session attached
         //
         connection.onopen = function (session, details) {

            console.log("Connected");

            // SUBSCRIBE to a topic and receive events
            //
            function on_counter (args) {
               var counter = args[0];
               console.log("on_counter() event received with counter " + counter);
            }
            session.subscribe('com.example.oncounter', on_counter).then(
               function (sub) {
                  console.log('subscribed to topic');
               },
               function (err) {
                  console.log('failed to subscribe to topic', err);
               }
            );


            // PUBLISH an event every second
            //
            t1 = setInterval(function () {

               session.publish('com.example.onhello', ['Hello from JavaScript (browser)']);
               console.log("published to topic 'com.example.onhello'");
            }, 1000);


            // REGISTER a procedure for remote calling
            //
            function mul2 (args) {
               var x = args[0];
               var y = args[1];
               console.log("mul2() called with " + x + " and " + y);
               return x * y;
            }
            session.register('com.example.mul2', mul2).then(
               function (reg) {
                  console.log('procedure registered');
               },
               function (err) {
                  console.log('failed to register procedure', err);
               }
            );


            // CALL a remote procedure every second
            //
            var x = 0;

            t2 = setInterval(function () {

               session.call('com.example.add2', [x, 18]).then(
                  function (res) {
                     console.log("add2() result:", res);
                  },
                  function (err) {
                     console.log("add2() error:", err);
                  }
               );

               x += 3;
            }, 1000);
         };


         // fired when connection was lost (or could not be established)
         //
         connection.onclose = function (reason, details) {
            console.log("Connection lost: " + reason);
            if (t1) {
               clearInterval(t1);
               t1 = null;
            }
            if (t2) {
               clearInterval(t2);
               t2 = null;
            }
         }


         // now actually open the connection
         //
         connection.open();

      </script>
   </body>
</html>
root@sathish-linux-deep:/home/giri37/wamp/crossbar_server# 


# Push to registry
root@sathish-linux-deep:/home/giri37/wamp/crossbar_server# docker tag debug_crossbar:latest hub.hertzai.com/debug_crossbar:latest
root@sathish-linux-deep:/home/giri37/wamp/crossbar_server# docker push hub.hertzai.com/debug_crossbar:latest
The push refers to repository [hub.hertzai.com/debug_crossbar]
02e0e6159486: Pushed 
f997b9f9e7b8: Layer already exists 
a229fda161cc: Layer already exists 
74ad94ac65e2: Layer already exists 
d0357b26b8fa: Layer already exists 
28a7331e3508: Layer already exists 
b7ecdccd720c: Layer already exists 
b8f2ce1c8d1c: Layer already exists 
298584e2b7f6: Layer already exists 
7c9214ed9767: Layer already exists 
8ea201624440: Layer already exists 
26f76510e607: Layer already exists 
537b30bfd2be: Layer already exists 
e31d27fd5816: Layer already exists 
477e7db04777: Layer already exists 
cb42413394c4: Layer already exists 
latest: digest: sha256:2050d965cffee6a8408161ff0e8faa00062cec51cd5482016e4cca285a5669c4 size: 3683
root@sathish-linux-deep:/home/giri37/wamp/crossbar_server# 
