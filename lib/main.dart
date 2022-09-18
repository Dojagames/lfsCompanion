import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

String globalUsername = "username";
String globalPassword = "password";
bool globalAutologin = false;




void main() {
  runApp(const MaterialApp(
    title: 'LFS-Companion',
    home: Home(),
  ));
  Load();

  SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(textAlign: TextAlign.center, "LWS Companion"),
      ),
      body:
        Row( children:[
          SizedBox(width: MediaQuery.of(context).size.width * 0.3),
          SizedBox(height: MediaQuery.of(context).size.height, width:MediaQuery.of(context).size.width * 0.4,
            child:Column(
              children: [
                SizedBox(height: 30),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ServicePage()));
                  },
                  child: Text('Service-Portal'),
                ),
                SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => IliasPage()));
                  },
                  child: Text('Ilias'),
                ),
                Expanded(child: SizedBox()),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
                  },
                  child: Text('Settings'),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.3),
        ]
      ),
    );
  }
}


class IliasPage extends StatefulWidget {
  const IliasPage({Key? key, this.cookieManager}) : super(key: key);

  final CookieManager? cookieManager;

  @override
  IliasState createState() => IliasState();
}

class IliasState extends State<IliasPage> {
  late WebViewController _controller;
  final Completer<WebViewController> _controllerCompleter =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {

    void runJS(command) async {
      _controller.runJavascript(command);
    }


    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: WebView(
        initialUrl: 'https://ilias.ludwig-fresenius.de',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controllerCompleter.future.then((value) => _controller = value);
          _controllerCompleter.complete(webViewController);
        },
        javascriptChannels: <JavascriptChannel>{
          _mainJavascriptChannel(context),
        },
        onPageFinished: (finished){
          runJS('if(document.getElementById("ilPageTocA16").innerHTML.includes("Herzlich Willkommen zur neuen ILIAS Version 7!")){document.getElementById("username").value = "${globalUsername}";document.getElementById("password").value = "${globalPassword}";}');
          if(globalAutologin) runJS('document.getElementsByClassName("btn btn-default btn-sm")[0].click();');
        },
        gestureNavigationEnabled: true,
        zoomEnabled: false,
      ),
    );
  }


  JavascriptChannel _mainJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'main',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      return Future.value(true);
    }
  }
}




class ServicePage extends StatefulWidget {
  const ServicePage({Key? key, this.cookieManager}) : super(key: key);

  final CookieManager? cookieManager;

  @override
  ServiceState createState() => ServiceState();
}

class ServiceState extends State<ServicePage> {
  late WebViewController _controller;
  final Completer<WebViewController> _controllerCompleter =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {

    void runJS(command) async {
      _controller.runJavascript(command);
    }


    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: WebView(
        initialUrl: 'https://infoboard.ludwig-fresenius.de',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controllerCompleter.future.then((value) => _controller = value);
          _controllerCompleter.complete(webViewController);
        },
        javascriptChannels: <JavascriptChannel>{
          _mainJavascriptChannel(context),
        },
        onPageFinished: (finished){
          runJS('if(document.getElementsByClassName("text-center px-5")[0].innerHTML.includes("Für den Zugang zum Serviceportal melden Sie sich bitte hier mit Ihrem Benutzernamen und dem Passwort an.") || document.getElementsByClassName("text-center px-5")[0].innerHTML.includes("To access the Service Portal please login here with your user name and password.")){document.getElementById("frmInputUsername").value = "${globalUsername}";document.getElementById("frmInputPassword").value = "${globalPassword}";}');
          //if(globalAutologin) runJS('document.getElementsByClassName("btn btn-default")[2].click();');
        },
        gestureNavigationEnabled: true,
        zoomEnabled: false,
      ),
    );
  }




  JavascriptChannel _mainJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'main',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      return Future.value(true);
    }
  }
}









class SettingPage extends StatefulWidget {
  SettingPage({super.key});

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<SettingPage> {

  final userController = TextEditingController(text: globalUsername);
  final pwController = TextEditingController(text: globalPassword);
  bool _isChecked = globalAutologin;
  bool _pwVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(textAlign: TextAlign.center, "Settings"),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.55,
              child: TextFormField(
                controller: userController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'username',
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.55,
              child: TextFormField(
                obscureText: !_pwVisible,
                controller: pwController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'password',
                ),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.35),
              Text("Autologin"),
              Checkbox(

                checkColor: Colors.white,
                value: _isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
            ),
            onPressed: () {
              globalUsername = userController.text;
              globalPassword = pwController.text;
              globalAutologin = _isChecked;
              SetString(userController.text, "USERNAME");
              SetString(pwController.text, "PASSWORD");
              SetBool(globalAutologin, "AUTOLOGIN");

              Fluttertoast.showToast(msg: "saved");

            },
            child: Text('Save'),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }


}


Future<void> SetString(String _value, String _name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_name, _value);
}

Future<void> SetBool(bool _value, String _name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_name, _value);
}


Future<void> Load() async {
  final prefs = await SharedPreferences.getInstance();
  String? _user = prefs.getString('USERNAME');
  String? _pw = prefs.getString('PASSWORD');
  if(_user != null) globalUsername = _user;
  if(_pw != null) globalPassword = _pw;

  bool? _autologin = prefs.getBool("AUTOLOGIN");
  if(_autologin != null) globalAutologin = _autologin;
}