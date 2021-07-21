const app = require('express')();

const server = require('http').createServer(app);

const io = require('socket.io')(server,{
    cors: {
    origin: "*",
    credentials: true
  },
})

io.on("connection",(socket)=>{
    console.log("socket ",socket);
    console.log('socket connected');

    socket.on("chat",(payload)=>{
        console.log("payload ",payload);
        io.emit("chat", payload);
    });
});

io.on("connect_error", (err) => {
    console.log(`connect_error due to ${err.message}`);
  });

app.get('/',(req,res)=>{
    res.send('hello world');
});

server.listen(5000,()=>console.log("Server is up and running"));