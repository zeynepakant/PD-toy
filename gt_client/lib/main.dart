import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Prisoner's Dilemma",
      debugShowCheckedModeBanner: false,
      home: BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({Key? key}) : super(key: key);

  @override
  BodyWidgetState createState() {
    return BodyWidgetState();
  }
}

class BodyWidgetState extends State<BodyWidget> {
  late Socket socket;
  List<String> messages = ['Welcome!'];
  late ScrollController scrollController;
  late double height, width;

  @override
  void initState() {
    super.initState();
    connectToServer();
    scrollController = ScrollController();
  }

  void connectToServer() {
    try {
      // Configure socket transports must be sepecified
      socket = io('http://10.0.2.2:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Connect to websocket
      socket.connect();

      // Handle socket events
      socket.on('message', (data) {
        final message = data;
        setState(() => messages.add(message));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget buildMessageList() {
    return Container(
      height: height * 0.75,
      width: width,
      child: ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return buildMessageView(index);
        },
      ),
    );
  }

  Widget buildMessageView(int index) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 16, left: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          messages[index],
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget buildButtonsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            socket.emit('turn', 'Cooperate');
          },
          child: const Text(
            "Cooperate",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            socket.emit('turn', 'Defect');
          },
          child: const Text(
            "Defect",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Prisoner's Dilemma"),
        ),
        body: Container(
          padding: const EdgeInsets.only(bottom: 16),
          height: height,
          width: width,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: buildMessageList(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildButtonsView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
