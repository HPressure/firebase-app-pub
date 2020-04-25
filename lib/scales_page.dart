import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';

import 'check_connections.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ScalesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScalesPageState();
}

class ScalesPageState extends State<ScalesPage> {
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
  String _paymentChoice = '';
  int _radioValue = -1;
  double _betweenFields = 10.0;
  EdgeInsetsGeometry _fieldsPadding =
  EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0);

  final TextEditingController _modelFieldController = TextEditingController();
  final TextEditingController _factoryNumberController =
  TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _problemDescriptionController =
  TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _additionalInfoController =
  TextEditingController();
  @override
  void dispose() {
    _modelFieldController.dispose();
    _factoryNumberController.dispose();
    _addressController.dispose();
    _problemDescriptionController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: _betweenFields),
        TextFormField(
          controller: _modelFieldController,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters:[
            LengthLimitingTextInputFormatter(100),
          ],
          decoration: InputDecoration(
            labelText: 'Модель оборудования*',
            contentPadding: _fieldsPadding,
          ),
        ),
        SizedBox(height: _betweenFields),
        TextFormField(
          controller: _factoryNumberController,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters:[
            LengthLimitingTextInputFormatter(100),
          ],
          decoration: InputDecoration(
            labelText: 'Заводской номер',
            contentPadding: _fieldsPadding,
          ),
        ),
        SizedBox(height: _betweenFields),
        TextFormField(
          controller: _addressController,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters:[
            LengthLimitingTextInputFormatter(100),
          ],
          decoration: InputDecoration(
            labelText: 'Адрес установки*',
            contentPadding: _fieldsPadding,
          ),
        ),
        SizedBox(height: _betweenFields),
        TextFormField(
          controller: _problemDescriptionController,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters:[
            LengthLimitingTextInputFormatter(1000),
          ],
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            labelText: 'Описание неисправности*',
            contentPadding: _fieldsPadding,
          ),
        ),
        SizedBox(height: _betweenFields),
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
          controller: _additionalInfoController,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters:[
            LengthLimitingTextInputFormatter(1000),
          ],
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            labelText: 'Дополнительная информация',
            contentPadding: _fieldsPadding,
          ),
        ),
        SizedBox(height: _betweenFields),
        Container(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
          child: Text(
            'Способ оплаты*',
            style: new TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: new Row(children: <Widget>[
              new Text("Наличными"),
              Radio(
                onChanged: _handleRadioValueChange,
                groupValue: _radioValue,
                value: 0,
                activeColor: Colors.red,
              ),
              new Text("Картой"),
              Radio(
                onChanged: _handleRadioValueChange,
                groupValue: _radioValue,
                value: 1,
                activeColor: Colors.red,
              )
            ])),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: RaisedButton(
            onPressed: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              if(_addressController.text.trim().isEmpty || _emailController.text.trim().isEmpty
                  || _fullNameController.text.trim().isEmpty  || _modelFieldController.text.trim().isEmpty  || _problemDescriptionController.text.trim().isEmpty  || _radioValue == -1)
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
          _paymentChoice = "Наличные";
          break;
        case 1:
          _paymentChoice = "Карта";
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
        .document("Бытовая техника")
        .collection(scalesString)
        .document(_docName);*/
    String _reference = 'Заявки/Бытовая техника/'+scalesString;
    DateTime _appTime = DateTime.now();
    String _appTimeString = _appTime.day.toString() +
        '/' +
        _appTime.month.toString() +
        '/' +
        _appTime.year.toString();
    Map<String, dynamic> _requestData = new Map<String, dynamic>();
    _requestData["Вид заявки"] = scalesString;
    _requestData["Дата"] = _appTimeString;
    _requestData["Модель оборудования"] = _modelFieldController.text.trim();
    _requestData["Заводской номер"] = _factoryNumberController.text.trim();
    _requestData["Адрес"] = _addressController.text.trim();
    _requestData["Описание проблемы"] = _problemDescriptionController.text.trim();
    _requestData["Контактное лицо"] = _fullNameController.text.trim();
    _requestData["Телефон"] = _currentUser.phoneNumber;
    _requestData["Email"] = _emailController.text.trim();
    _requestData["Доп. информация"] = _additionalInfoController.text.trim();
    _requestData["Метод оплаты"] = _paymentChoice;
    Message message = new Message()
      ..subject = 'Заявка: $scalesString'
      ..html = '<h1>Заявка: $scalesString</h1>'+
          '<p><b>Модель оборудования:</b> ' +
              _modelFieldController.text.trim() +
                  '<p><b>Заводской номер:</b> ' +
              _factoryNumberController.text.trim() +
                  '<p><b>Адрес:</b> ' +
              _addressController.text.trim() +
                  '<p><b>Описание проблемы:</b> ' +
              _problemDescriptionController.text.trim() +
                  '<p><b>Контактное лицо:</b> ' +
              _fullNameController.text.trim() +
                  '<p><b>Телефон:</b> ' +
              _currentUser.phoneNumber +
                  '<p><b>Email:</b> ' +
              _emailController.text.trim() +
                  '<p><b>Доп. информация:</b> ' +
              _additionalInfoController.text.trim() +
                  '<p><b>Метод оплаты:</b> ' +
              _paymentChoice;

    await sendMail(message)
        .then((_) async{
      await createFile(_requestData).catchError((_){});
    })
        .then((_) async{
      await Firestore.instance.collection(_reference).document(_docName).setData(_requestData).catchError((_){});
    });
  }


}
