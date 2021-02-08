import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:imei_plugin/imei_plugin.dart';
import 'package:flutter/services.dart';

/*
Napišite jednostavnu Flutter aplikaciju 
koja u debug modeu uvijek vrati neki dummy IMEI, 
a u release modeu vraća pravi IMEI uređaja.
*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter IMEI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _platformImei = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformImei;

    if (Foundation.kReleaseMode) {
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        platformImei = await ImeiPlugin.getImei(
            shouldShowRequestPermissionRationale: false);
      } on PlatformException {
        platformImei = 'Failed to get platform version.';
      }
      if (!mounted) return;
    } else if (Foundation.kDebugMode) {
      // dummy IMEI
      platformImei = '0c4ddb1c-25c3-5563-b69c-1deb5a13ae1a';
    }

    setState(() {
      _platformImei = platformImei;
    });
  }

  String _getAppReleaseMode() {
    if (Foundation.kReleaseMode) {
      return 'Release Mode';
    } else if (Foundation.kDebugMode) {
      return 'Debug Mode';
    }

    return 'Other Mode';
  }

  @override
  Widget build(BuildContext context) {
    String mode = _getAppReleaseMode();

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter IMEI"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'MODE: $mode',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              _platformImei,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
