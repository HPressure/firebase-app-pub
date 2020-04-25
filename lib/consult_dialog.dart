import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'check_connections.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Future requestConsult(BuildContext _context) async{
  await sendingConfirmation(_context, _submitRequest());
}

Future<void> _submitRequest() async {
  final FirebaseUser _currentUser = await _auth.currentUser();
  String _docName =
       new DateTime.now().toString() + " " + _currentUser.phoneNumber;
  /*DocumentReference _reference = Firestore.instance
      .collection("Заявки")
      .document("Услуги")
      .collection(consultString)
      .document(_docName);*/
  String _reference = 'Заявки/Услуги/'+consultString;
  DateTime _appTime = DateTime.now();
  String _appTimeString = _appTime.day.toString() +
      '/' +
      _appTime.month.toString() +
      '/' +
      _appTime.year.toString();
  Map<String, dynamic> _requestData = new Map<String, dynamic>();
  _requestData["Вид заявки"] = consultString;
  _requestData["Дата"] = _appTimeString;
  _requestData["Телефон"] = _currentUser.phoneNumber;
  Message message = new Message()
    ..subject = 'Заявка: $consultString'
    ..html = '<h1>Заявка: $consultString</h1>'+
        '<p><b>Телефон:</b> ' + _currentUser.phoneNumber;
  await sendMail(message)
      .then((_) async{
    await createFile(_requestData).catchError((_){});
  })
      .then((_) async{
    await Firestore.instance.collection(_reference).document(_docName).setData(_requestData).catchError((_){});
  });
}
