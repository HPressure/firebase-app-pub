import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';

const String cashregisterString = 'Онлайн-касса';
const String bankequipmentString = 'Банковское оборудование';
const String digitalsignatureString = 'ЭЦП';
const String consultString = 'Консультация';
const String scalesString = 'Весы';
String jsonfileName = 'masterApplications.json';

Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}

Future<bool> checkFirebaseLogin() async {
  final FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();
  if (_currentUser != null) {
    return true;
  } else {
    return false;
  }
}

networkAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ошибка',
          ),
          content: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                    'Пожалуйста проверьте подключение к сети или повторите попытку позже'),
              ),
              Icon(
                Icons.signal_cellular_connected_no_internet_4_bar,
                color: Colors.red,
                size: 50,
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      });
}

Future<void> sendMail(Message _message) async {
  _message
    ..recipients.add('')
    ..from = new Address('', 'Приложение');
  final _smtpServer = new SmtpServer('', username: '', password: '', port: 587);
  final sendReports =
  await send(_message, _smtpServer, timeout: Duration(seconds: 20));

}

Future<void> createFile(Map<String, dynamic> _sentContent) async {
  File _jsonFile;
  Directory _dir;
  List _fileContent = new List<Map<String, dynamic>>();
  List _content = new List<Map<String, dynamic>>();
  await getApplicationDocumentsDirectory().then((Directory directory) {
    _dir = directory;
    _jsonFile = new File(_dir.path + "/" + jsonfileName);
  });
  _content = [_sentContent];
  if (await _jsonFile.exists()) {
    _fileContent = (jsonDecode(await _jsonFile.readAsString()));
    _fileContent.add(_sentContent);
    await _jsonFile.writeAsString(jsonEncode(_fileContent));
  } else {
    await _jsonFile.create();
    await _jsonFile.writeAsString(jsonEncode(_content));
  }
}

Future sendingConfirmation(BuildContext _pageContext, Future <void> _func) async {
  Timer _timer;
  return showDialog(
    context: _pageContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return WillPopScope(
            onWillPop: (){},
            child: AlertDialog(
              content: Container(
                height: 100,
                child: FutureBuilder(
                  future:
                      _func, ///////////////////ЗЗДЕСЬ ФУНКЦИЯ/////////////////////////////////////////////////////////////////////////////////////
                  builder: (BuildContext context, AsyncSnapshot <void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        _timer = Timer.periodic(const Duration(seconds: 3), (_) {
                          _timer.cancel();
                          Navigator.of(context).pop();
                        });
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              size: 50,
                              color: Colors.red,
                            ),
                            Text(
                              'Произошла ошибка, повторите попытку позже',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      case ConnectionState.active:

                      case ConnectionState.waiting:
                        return Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey[700])),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          _timer =
                              Timer.periodic(const Duration(seconds: 3), (_) {
                            _timer.cancel();
                            Navigator.of(context).pop();
                          });
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              ),
                              Text(
                                'Произошла ошибка, повторите попытку позже',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        } else {
                          _timer =
                              Timer.periodic(const Duration(seconds: 2), (_) {
                            _timer.cancel();
                            /*Navigator.maybePop(context);
                            Navigator.maybePop(_pageContext);*/
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          });
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                size: 50,
                                color: Colors.green,
                              ),
                              Text(
                                'Заявка отправлена!',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        }
                    }
                  },
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
