import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class DialogSignPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<DialogSignPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCode = GlobalKey<FormState>();
  Animation animation;
  Animation animation2;
  AnimationController animationController;
  final MaskedTextController _phoneNumberController =
      MaskedTextController(mask: '+7(000)000-00-00');
  final TextEditingController _smsController = TextEditingController();
  String _errCode = '';
  String _verificationId;
  double _anim;
  int _butState;
  bool _checkboxval = false;

  @override
  void initState() {
    _butState = 0;
    _anim = 0;
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..addListener(() {
            setState(() {});
          });

    animation = Tween(begin: 0.0, end: -1.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animation2 = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _phoneNumberController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _anim = MediaQuery.of(context).size.width;
    return Scaffold(
      body: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return Stack(
              children: <Widget>[
                Transform(
                  transform: Matrix4.translationValues(
                      _anim * animation2.value, 0.0, 0.0),
                  child: Form(
                    key: _formKeyCode,
                    child: TextFormField(
                      controller: _smsController,
                      decoration: InputDecoration(
                        hintText: 'Код подтверждения',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (String value) {
                        if (_errCode.isNotEmpty) {
                          return _errCode;
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  height: 50,
                  top: 50,
                  width: 240,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        _anim * animation.value, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text('Согласие на обработку персональных данных', style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),)
                        ),
                        Checkbox(
                            value: _checkboxval,
                            onChanged: (bool value) {
                              setState(() {
                                _checkboxval = _checkboxval ? false : true;
                              });
                            }),
                      ],
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.translationValues(
                      _anim * animation.value, 0.0, 0.0),
                  child: Form(
                    key: _formKeyPhone,
                    child: TextFormField(
                      controller: _phoneNumberController,
                      maxLength: 16,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '+7',
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (String value) {
                        if (value.isEmpty ||
                            _phoneNumberController.text.length < 16) {
                          return 'Пожалуйста, введите номер';
                        }
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    onPressed: () async {
                      /*_phoneNumberController.text = _phoneNumberController.text.replaceAll(new RegExp(r'e'), 'é');
                      print(_phoneNumberController.text);*/
                      if (_butState == 0) {
                        FormState form = _formKeyPhone.currentState;
                        if (form.validate()) {
                          _verifyPhoneNumber(context);
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _butState++;
                        }
                      } else {
                        _errCode = '';
                        FormState form = _formKeyCode.currentState;
                        form.validate();
                        await _signInWithPhoneNumber(context).catchError((e) {
                          if (e.code == 'ERROR_INVALID_VERIFICATION_CODE') {
                            _errCode = 'Неверный код';
                            form.validate();
                          }
                        });
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }
                    },
                    padding: EdgeInsets.only(top: 25.0),
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 30,
                    ),
                    color: Colors.red,
                  ),
                ),
              ],
            );
          }),
      backgroundColor: Colors.white,
    );
  }

  // Exmaple code of how to veify phone number
  void _verifyPhoneNumber(BuildContext _context) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        //АВТОВХОД
        Navigator.maybePop(_context);
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {};

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      //КОД ОТПРАВЛЕН
      _verificationId = verificationId;
      animationController.forward();
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };
    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 0),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  Future<void> _signInWithPhoneNumber(BuildContext _context) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        //УСПЕШНЫЙ ВХОД
        Navigator.maybePop(_context);
      } else {
        //ОШИБКА ВХОДА
      }
    });
  }
}

Future loginDialog(BuildContext _pageContext) async {
  return showDialog(
    context: _pageContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            titlePadding:
                EdgeInsets.only(bottom: 10.0, left: 0.0, right: 24.0, top: 0.0),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(Icons.close, size: 17),
                      color: Colors.grey,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
                Text(
                  'Авторизация',
                  style: TextStyle(),
                ),
              ],
            ),
            contentPadding: EdgeInsets.only(
                bottom: 24.0, left: 24.0, right: 24.0, top: 24.0),
            content: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0)),
              child: Container(
                alignment: Alignment.topCenter,
                height: 140,
                child: DialogSignPage(),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          );
        },
      );
    },
  );
}
