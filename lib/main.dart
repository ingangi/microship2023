import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:platform_info/platform_info.dart';
import 'dialer.dart';
import 'global.dart';
import 'configer.dart';
// import 'cpp/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global();
  runApp(const MyPhone());
  // print("=================");
  // print(nativeAdd(1, 2).toString());
  // print("=================");
  print(Platform.instance.version);
  if (Platform.I.isMacOS || Platform.I.isWindows) {
    print("platform is desktop will resize window");
    doWhenWindowReady(() {
      appWindow.minSize = const Size(250, 580);
      appWindow.size = const Size(400, 800);
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}

class MyPhone extends StatelessWidget {
  const MyPhone({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroShip',
      theme: ThemeData(
          primaryColor: Colors.blue, dialogBackgroundColor: Colors.blueGrey),
      routes: {
        '/dialer': (context) => const DialerPage(),
        '/configer': (context) => const Configer(),
      },
      home: const DialerPage(),
    );
  }
}
