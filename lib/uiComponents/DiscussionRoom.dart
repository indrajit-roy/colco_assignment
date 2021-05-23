import 'package:colco_assignment/uiComponents/textField.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DiscussionRoom extends StatefulWidget {
  final String postId;
  final String username;
  DiscussionRoom({Key key, this.postId, this.username}) : super(key: key);

  @override
  _DiscussionRoomState createState() => _DiscussionRoomState();
}

class _DiscussionRoomState extends State<DiscussionRoom> {
  // IO.Socket socket;
  IO.Socket socket2;
  List<Map<String, String>> chatMessages = [];
  String message = "";

  void connect() {
    // socket = IO.io("http://192.168.0.2:5000", <String, dynamic>{
    //   "transports": ["websocket"],
    //   "autoconnect": false,
    // });
    print('HUUUU');

    // IO.Socket socket = IO.io('http://192.168.0.2:3000', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    // });
    socket2 = IO.io('http://10.0.2.2:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket2.connect();
    // socket.connect();
    // socket.emit('/test', 'test');

    // socket.connect();

    socket2.onConnect((data) {
      socket2.on('message', (data) {
        print('MESSAGEEEEE!!!! $data');
        setState(() {
          chatMessages.add({'source': 'Aakash', 'message': data['message']});
        });
      });
    });
    socket2.emit('signIn', 'indrajit_roy');

    print(socket2.connected);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatMessages = [
      {'source': 'me', 'message': 'Indrajit\'s Point of View'},
      {'source': 'Aakash', 'message': 'Aakash\'s Point of View'}
    ];
    connect();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socket2.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              reverse: true,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final list = chatMessages
                    .map((e) => Container(
                          alignment: e['source'] == 'me'
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          padding: EdgeInsets.all(12),
                          child: Text(e['message']),
                        ))
                    .toList();
                return list[list.length - index - 1];
              },
            )),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Enter chat here'),
                    onChanged: (value) {
                      message = value;
                    },
                  ),
                ),
                TextButton.icon(
                    onPressed: () {
                      socket2.emit('message', {
                        'messageBody': message,
                        'sourceId': 'indrajit_roy',
                        'targetId': 'indrajit_roy'
                      });
                      setState(() {
                        chatMessages.add({'source': 'me', 'message': message});
                      });
                    },
                    icon: Icon(Icons.send),
                    label: Text('SEND'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
