import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'check_connections.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignaturePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignaturePageState();
}

class SignaturePageState extends State<SignaturePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.grey[800]),
            centerTitle: true,
            leading: null,
            pinned: true,
            floating: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 0.0, right: 5.0),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF616161),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                  Text('Заполните заявку',
                      style: TextStyle(color: Color(0xFF616161))),
                ],
              ),
            ),
            backgroundColor: Colors.white,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Builder(builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: _FieldsSection(Scaffold.of(context)),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldsSection extends StatefulWidget {
  _FieldsSection(this._scaffold);
  final ScaffoldState _scaffold;
  @override
  State<StatefulWidget> createState() => _FieldsSectionState();
}

class _FieldsSectionState extends State<_FieldsSection> {
  String _personType = '';
  int _radioValue = -1;
  double _betweenFields = 10.0;
  EdgeInsetsGeometry _fieldsPadding =
  EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0);

  bool _personBool = false;
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _kppController =
  TextEditingController();
  final TextEditingController _innController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    _organizationController.dispose();
    _kppController.dispose();
    _innController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: _betweenFields),
        Container(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
          child: Text(
            'Тип лица*',
            style: new TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: new Row(children: <Widget>[
              new Text("ЮЛ/ИП"),
              Radio(
                onChanged: _handleRadioValueChange,
                groupValue: _radioValue,
                value: 0,
                activeColor: Colors.red,
              ),
              new Text("ФЛ"),
              Radio(
                onChanged: _handleRadioValueChange,
                groupValue: _radioValue,
                value: 1,
                activeColor: Colors.red,
              )
            ])),
        TextFormField(
          controller: _fullNameController,
          textCapitalization: TextCapitalization.words,
          inputFormatters:[
            LengthLimitingTextInputFormatter(100),
          ],
          decoration: InputDecoration(
            labelText: 'ФИО*',
            contentPadding: _fieldsPadding,
          ),
        ),
        SizedBox(height: _betweenFields),
        TextFormField(
          controller: _emailController,
          textCapitalization: TextCapitalization.none,
          inputFormatters:[
            LengthLimitingTextInputFormatter(100),
          ],
          decoration: InputDecoration(
            labelText: 'Эл. почта*',
            contentPadding: _fieldsPadding,
          ),
        ),
        SizedBox(height: _betweenFields),
        TextFormField(
          controller: _innController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          decoration: InputDecoration(
            labelText: 'ИНН*',
            contentPadding: _fieldsPadding,
          ),
        ),
        SizedBox(height: _betweenFields),
        Visibility(
          visible: _personBool,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _kppController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                decoration: InputDecoration(
                  labelText: 'КПП*',
                  contentPadding: _fieldsPadding,
                ),
              ),
              SizedBox(height: _betweenFields),
              TextFormField(
                controller: _organizationController,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters:[
                  LengthLimitingTextInputFormatter(100),
                ],
                decoration: InputDecoration(
                  labelText: 'Организация*',
                  contentPadding: _fieldsPadding,
                ),
              ),
              SizedBox(height: _betweenFields),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: RaisedButton(
            onPressed: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              if(_radioValue == 0){
                if(_organizationController.text.trim().isEmpty || _emailController.text.trim().isEmpty
                    || _fullNameController.text.trim().isEmpty || _innController.text.trim().isEmpty || _kppController.text.trim().isEmpty || _radioValue == -1)
                {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text('Не все обязательные поля заполнены', style: TextStyle(fontSize: 16.0),),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ));
                }
                else{
                  if (await checkInternetConnection()) {
                    await sendingConfirmation(context, _submitRequest());//////////////////////////////////////////////////////Отправка
                  } else {
                    networkAlert(this.context);
                  }
                }
              }
              if(_radioValue == 1){
                if( _emailController.text.trim().isEmpty
                    || _fullNameController.text.trim().isEmpty || _innController.text.trim().isEmpty || _radioValue == -1)
                {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text('Не все обязательные поля заполнены', style: TextStyle(fontSize: 16.0),),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ));
                }
                else{
                  if (await checkInternetConnection()) {
                    sendingConfirmation(context, _submitRequest());//////////////////////////////////////////////////////Отправка
                  } else {
                    networkAlert(this.context);
                  }
                }
              }
              if(_radioValue == -1)
              {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text('Не все обязательные поля заполнены', style: TextStyle(fontSize: 16.0),),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ));
              }
            },
            child:
            const Text('ОТПРАВИТЬ', style: TextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.all(12),
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  void _handleRadioValueChange(int value) {
    _radioValue = value;
    setState(() {
      switch (_radioValue) {
        case 0:
          _personBool = true;
          _personType = "ЮЛ/ИП";
          break;
        case 1:
          _personBool = false;
          _personType = "ФЛ";
          break;
      }
    });
  }

  Future<void> _submitRequest() async {
    final FirebaseUser _currentUser = await _auth.currentUser();
    String _docName =
        new DateTime.now().toString() + " " + _currentUser.phoneNumber;
    /*DocumentReference _reference = Firestore.instance
        .collection("Заявки")
        .document("Услуги")
        .collection(digitalsignatureString)
        .document(_docName);*/
    String _reference = 'Заявки/Услуги/'+digitalsignatureString;
    DateTime _appTime = DateTime.now();
    String _appTimeString = _appTime.day.toString() +
        '/' +
        _appTime.month.toString() +
        '/' +
        _appTime.year.toString();
    Map<String, dynamic> _requestData = new Map<String, dynamic>();
    _requestData["Вид заявки"] = digitalsignatureString;
    _requestData["Дата"] = _appTimeString;
    _requestData["Контактное лицо"] = _fullNameController.text.trim();
    _requestData["Телефон"] = _currentUser.phoneNumber;
    _requestData["Email"] = _emailController.text.trim();
    _requestData["Тип лица"] = _personType;
    _requestData["ИНН"] = _innController.text.trim();
    if(_radioValue == 0){
      _requestData["КПП"] = _kppController.text.trim();
      _requestData["Организация"] = _organizationController.text.trim();
    }
    Message message = new Message();
    if(_radioValue == 0){
      message
        ..subject = 'Заявка: $digitalsignatureString'
        ..html = '<h1>Заявка: $digitalsignatureString</h1>'+
            '<p><b>Контактное лицо:</b> ' +
                _fullNameController.text.trim() +
                    '<p><b>Телефон:</b> ' +
                _currentUser.phoneNumber +
                    '<p><b>Email:</b> ' +
                _emailController.text.trim() +
                    '<p><b>Тип лица:</b> ' +
                _personType +
                    '<p><b>Организация:</b> ' +
                _organizationController.text.trim() +
                    '<p><b>ИНН:</b> ' +
                _innController.text.trim() +
                    '<p><b>КПП:</b> ' +
                _kppController.text.trim();
    }
    else{
      message
        ..subject = 'Заявка: $digitalsignatureString'
        ..html = '<h1>Заявка: $digitalsignatureString</h1>'+
            '<p><b>Контактное лицо:</b> ' +
                _fullNameController.text.trim() +
                    '<p><b>Телефон:</b> ' +
                _currentUser.phoneNumber +
                    '<p><b>Email:</b> ' +
                _emailController.text.trim() +
                    '<p><b>Тип лица:</b> ' +
                _personType +
                    '<p><b>Организация:</b> ' +
                _organizationController.text.trim() +
                    '<p><b>ИНН:</b> ' +
                _innController.text.trim() +
                    '<p><b>КПП:</b> ' +
                _kppController.text.trim();
    }

    await sendMail(message)
        .then((_) async{
      await createFile(_requestData).catchError((_){});
    })
        .then((_) async{
      await Firestore.instance.collection(_reference).document(_docName).setData(_requestData).catchError((_){});
    });
  }


}
