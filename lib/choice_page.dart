import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/scales_page.dart';

import 'bank_page.dart';
import 'custom_icons_icons.dart';
import 'check_connections.dart';
import 'kkm_page.dart';
import 'login_dialog.dart';
import 'consult_dialog.dart';
import 'signature_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String _signButtonText = "Войти";
bool _signState = false;

class ChoicePage extends StatefulWidget {
  final String title = "Выберите услугу";
  @override
  State<StatefulWidget> createState() => ChoicePageState();
}

class ChoicePageState extends State<ChoicePage> {
  static const double _buttonPadding = 16.0;
  static const double _buttonBorder = 5.0;
  static const double _iconSize = 40;
  static const double _betweenButtons = 15.0;
  Color mainColor = Colors.red;
  static TextStyle _buttonHeaderStyle = TextStyle(
      fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.normal);
  static TextStyle _buttonTextStyle = TextStyle(
      fontSize: 14.0, color: Colors.grey[700], fontWeight: FontWeight.normal);

  void initState() {
    super.initState();
    _auth.onAuthStateChanged.listen((firebaseUser) async{
      await _checkIfSigned();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  Text(_signButtonText),
                ],
              ),
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                if (await checkInternetConnection()) {
                  if (_signState) {
                    await _dialogConfirmation();
                  } else {
                    loginDialog(context);
                  }
                }
                else{
                  networkAlert(context);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            );
          })
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(_buttonPadding),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          RaisedButton(
            padding: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_buttonBorder),
                      topRight: Radius.circular(_buttonBorder),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                    child: Align(
                      child: Text(
                        cashregisterString,
                        style: _buttonHeaderStyle,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    color: mainColor,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                      child: Icon(
                        CustomIcons.cash_register,
                        size: _iconSize,
                        color: mainColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Оформить заявку на ремонт кассового оборудования',
                        overflow: TextOverflow.fade,
                        style: _buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onPressed: () async {
              if (await checkInternetConnection()) {
                if (await checkFirebaseLogin()) {
                  pushPage(context, KkmPage());
                } else {
                  loginDialog(context);
                }
              } else {
                networkAlert(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonBorder),
            ),
            color: Colors.white,
          ),
          SizedBox(height: _betweenButtons),
          RaisedButton(
            padding: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_buttonBorder),
                      topRight: Radius.circular(_buttonBorder),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                    child: Align(
                      child: Text(
                        bankequipmentString,
                        style: _buttonHeaderStyle,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    color: mainColor,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                      child: Icon(
                        Icons.account_balance,
                        size: _iconSize,
                        color: mainColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Оформить заявку на ремонт банковского оборудования',
                        overflow: TextOverflow.fade,
                        style: _buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onPressed: () async {
              if (await checkInternetConnection()) {
                if (await checkFirebaseLogin()) {
                  pushPage(context, BankPage());
                } else {
                  loginDialog(context);
                }
              } else {
                networkAlert(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonBorder),
            ),
            color: Colors.white,
          ),
          SizedBox(height: _betweenButtons),
          RaisedButton(
            padding: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_buttonBorder),
                      topRight: Radius.circular(_buttonBorder),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                    child: Align(
                      child: Text(
                        digitalsignatureString,
                        style: _buttonHeaderStyle,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    color: mainColor,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                      child: Icon(
                        CustomIcons.checkbook,
                        size: _iconSize,
                        color: mainColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Оформить заявку на выпуск электронной цифровой подписи',
                        overflow: TextOverflow.fade,
                        style: _buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onPressed: () async {
              if (await checkInternetConnection()) {
                if (await checkFirebaseLogin()) {
                  pushPage(context, SignaturePage());
                } else {
                  loginDialog(context);
                }
              } else {
                networkAlert(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonBorder),
            ),
            color: Colors.white,
          ),
          SizedBox(height: _betweenButtons),
          RaisedButton(
            padding: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_buttonBorder),
                      topRight: Radius.circular(_buttonBorder),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                    child: Align(
                      child: Text(
                        consultString,
                        style: _buttonHeaderStyle,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    color: mainColor,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                      child: Icon(
                        Icons.phone_in_talk,
                        size: _iconSize,
                        color: mainColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Заказать обратный звонок',
                        overflow: TextOverflow.fade,
                        style: _buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onPressed: () async{
              if (await checkInternetConnection()) {
                if (await checkFirebaseLogin()) {
                  await _consultConfirmation();
                } else {
                  loginDialog(context);
                }
              } else {
                networkAlert(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonBorder),
            ),
            color: Colors.white,
          ),
          SizedBox(height: _betweenButtons),
          RaisedButton(
            padding: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_buttonBorder),
                      topRight: Radius.circular(_buttonBorder),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                    child: Align(
                      child: Text(
                        scalesString,
                        style: _buttonHeaderStyle,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    color: mainColor,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                      child: Icon(
                        CustomIcons.scale_bathroom,
                        size: _iconSize,
                        color: mainColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Оформить заявку на ремонт напольных весов',
                        overflow: TextOverflow.fade,
                        style: _buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onPressed: () async {
              if (await checkInternetConnection()) {
                if (await checkFirebaseLogin()) {
                  pushPage(context, ScalesPage());
                } else {
                  loginDialog(context);
                }
              } else {
                networkAlert(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonBorder),
            ),
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  static void pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  Future _checkIfSigned() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    setState(() {
      if (currentUser != null) {
        _signButtonText = "Выйти";
        _signState = true;
      } else {
        _signButtonText = "Войти";
        _signState = false;
      }
    });
  }

  Future _dialogConfirmation() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Выйти из учетной записи?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('НЕТ'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('ДА'),
              onPressed: () {
                _auth.signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      },
    );
  }

  Future _consultConfirmation() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext _context) {
        return AlertDialog(
          title: Text('Заказать обратный звонок?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('НЕТ'),
              onPressed: () {
                Navigator.of(_context).pop();
              },
            ),
            FlatButton(
              child: const Text('ДА'),
              onPressed: () async{
                Navigator.of(_context).pop();
                await requestConsult(context);
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      },
    );
  }


}
