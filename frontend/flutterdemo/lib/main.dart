import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List msg = [];
  int msgData = 0;
  TextEditingController messageController = new TextEditingController();
  IO.Socket socket = IO.io('http://192.168.0.175:5000',
      IO.OptionBuilder().setTransports(['websocket']).build());
  @override
  void initState() {
    super.initState();
    socket.onConnect((_) {
      print('connect');
    });
    socket.onConnectError((e) {
      print(e);
    });
    socket.on(
        "chat",
        (payload) => {
              setState(() {
                msg = [...msg, payload];
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    sendChat() {
      socket.emit("chat", {messageController.text});
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: Container(
        child: TextFormField(
          controller: messageController,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            msg.length > 1
                ? Container(
                    child: Text(msg[msg.length - 1].toString()),
                  )
                : Center(
                    child: Container(
                      child: Text('Data not available'),
                    ),
                  )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          print('tapped');
          sendChat();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
