import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(RemoteClientApp());
}

class RemoteClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Remote Client',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.purple,
          accentColor: Colors.cyan[600],
          fontFamily: 'Raleway'),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: RemoteClientPage(title: 'Remote Client'),
    );
  }
}

class WebSocketClient {
  String _url;
  set url(url) => this._url = url;

  bool _connected = false;
  late WebSocketChannel _channel;

  WebSocketClient(this._url) {
    connect();
  }

  void connect() {
    _channel = IOWebSocketChannel.connect('ws://$_url:11000');
    _connected = true;

    _channel.stream.listen(
      (dynamic message) {
        debugPrint('message $message');
      },
      onDone: () {
        _connected = false;
        debugPrint('channel closed');
      },
      onError: (error) {
        _connected = false;
        debugPrint('error $error');
      },
    );
  }

  void sendMessage(msg) {
    if (!_connected) {
      connect();
    }

    _channel.sink.add(msg);
  }

  void close() {
    _channel.sink.close();
  }
}

class RemoteClientPage extends StatefulWidget {
  RemoteClientPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _RemoteClientPageState createState() => _RemoteClientPageState();
}

class _RemoteClientPageState extends State<RemoteClientPage> {
  final urlTextController = TextEditingController(text: '192.168.35.11');
  final WebSocketClient webSocketClient = WebSocketClient('192.168.35.11');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              controller: urlTextController,
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          _sendMessage('s');
                        },
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        child: Icon(
                          Icons.fast_rewind,
                          size: 30,
                        ))),
                SizedBox(width: 20.0),
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          _sendMessage('r');
                        },
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        child: Icon(
                          Icons.restart_alt,
                          size: 30,
                        ))),
                SizedBox(width: 20.0),
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          _sendMessage('d');
                        },
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        child: Icon(
                          Icons.fast_forward,
                          size: 30,
                        )))
              ],
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          _sendMessage('up');
                        },
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        child: Icon(
                          Icons.arrow_drop_up,
                          size: 30,
                        ))),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          _sendMessage('le');
                        },
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        child: Icon(
                          Icons.arrow_left,
                          size: 30,
                        ))),
                SizedBox(width: 30.0),
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          _sendMessage('dw');
                        },
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                        ))),
                SizedBox(width: 30.0),
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          _sendMessage('ri');
                        },
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        child: Icon(
                          Icons.arrow_right,
                          size: 30,
                        )))
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          _sendMessage('sp');
                        },
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 30,
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(msg) {
    webSocketClient.url = urlTextController.text;
    webSocketClient.sendMessage(msg);
  }

  @override
  void dispose() {
    webSocketClient.close();
    super.dispose();
  }
}
