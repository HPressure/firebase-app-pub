import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'check_connections.dart';
import 'custom_icons_icons.dart';

class ArchivePage extends StatefulWidget {
  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> with TickerProviderStateMixin {

  static const double _buttonPadding = 16.0;
  static const double _betweenButtons = 15.0;
  static const double _buttonBorder = 5.0;
  static const double _iconSize = 40;
  static TextStyle _buttonHeaderStyle = TextStyle(
      fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.normal);
  static TextStyle _buttonTextStyle = TextStyle(
      fontSize: 14.0, color: Colors.black87, fontWeight: FontWeight.normal);

  List _fileContent = new List<Map<String, dynamic>>();

  Future<List> _readFile() async {
    Directory dir;
    File jsonFile;
    await getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + jsonfileName);
    });
    _fileContent = (jsonDecode(await jsonFile.readAsString()));
    return _fileContent;
  }

  @override
  void initState() {
    //_readFile();
    super.initState();
  }
  Widget _iconOnCondtion(int index){
    switch(_fileContent[index]['Вид заявки']) {
      case cashregisterString:
        return Icon(
          CustomIcons.cash_register,
          size: _iconSize,
          color: Colors.grey[700],
        );
      case bankequipmentString:
        return Icon(
          Icons.account_balance,
          size: _iconSize,
          color: Colors.grey[700],
        );
      case digitalsignatureString:
        return Icon(
          CustomIcons.checkbook,
          size: _iconSize,
          color: Colors.grey[700],
        );
      case consultString:
        return Icon(
          Icons.phone_in_talk,
          size: _iconSize,
          color: Colors.grey[700],
        );
      case scalesString:
        return Icon(
          CustomIcons.scale_bathroom,
          size: _iconSize,
          color: Colors.grey[700],
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Оставленные заявки"),
        backgroundColor: Colors.grey[700],
      ),
      body: new FutureBuilder<List>(
        future: _readFile(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.find_in_page, color: Colors.grey, size: _iconSize,),
                    Text('Заявок нет')
                  ],
                ),
              );
            case ConnectionState.active:

            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[700])),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.find_in_page, color: Colors.grey, size: _iconSize,),
                        Text('Заявок нет')
                      ],
                    ),
                );
              }
              else {
                return new ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => SizedBox(height: _betweenButtons),
                  physics: BouncingScrollPhysics(),
                  itemCount: _fileContent.length,
                  padding: EdgeInsets.all(_buttonPadding),
                  itemBuilder: (BuildContext context, int index) {
                    return new RaisedButton(
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
                                  _fileContent[index]['Вид заявки'],
                                  style: _buttonHeaderStyle,
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              color: Colors.grey[700],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisSize: MainAxisSize.max,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10.0, bottom: 5.0, top: 5.0, right: 5.0),
                                child: _iconOnCondtion(index),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Align(
                                  child: Text(
                                    _fileContent[index]['Дата'],
                                    style: _buttonTextStyle,
                                  ),
                                  alignment: Alignment.bottomRight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onPressed: () async{
                        if(_fileContent[index]['Вид заявки'] != consultString)
                        {
                          await _showApplication(_fileContent[index], _fileContent[index]['Вид заявки']);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_buttonBorder),
                      ),
                      color: Colors.white,
                    );
                  },
                );
              }
          }
          return null; // unreachable
        },
      ),
    );
  }
  Future _showApplication(Map<String, dynamic> selectedApplication, String appType) async{
    List _applicationList = selectedApplication.entries.toList();
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(a1),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                  titlePadding: EdgeInsets.all(0.0),
                  contentPadding: EdgeInsets.only(top:0.0, bottom: 24.0, left: 30.0, right: 30.0),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(icon: Icon(Icons.close, size: 17),
                            color: Colors.grey,
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10.0, right: 30),
                            child: Text(appType)),
                      ),
                    ],
                  ),
                  content: Container(
                    width: 250,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.grey,),
                      itemCount: _applicationList.length,
                      itemBuilder: (BuildContext context, int index){
                        return Text(_applicationList[index].key + ': ' + _applicationList[index].value);
                      },
                    ),
                  )
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
