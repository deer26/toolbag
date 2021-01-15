import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/theme_changer.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool isSwitched = true;
  bool isLangSwitched = true;
  int _radioValue1 = -1;

  @override
  void initState() {
    super.initState();
    setState(() {
      isSwitched = brightnessTheme == Brightness.dark ? true : false;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    _radioValue1 =
        EasyLocalization.of(context).locale == Locale("en", "US") ? 1 : 0;
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Kadir Ağdaş"),
            accountEmail: Text("kaderu95@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                "K",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text("theme".tr().toString()),
            trailing: CupertinoSwitch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  ThemeBuilder.of(context).changeTheme();
                  isSwitched = value;
                });
              },
            ),
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  title: Text("language".tr().toString()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: _radioValue1,
                      onChanged: (val) {
                        EasyLocalization.of(context).locale =
                            Locale("tr", "TR");
                        _radioValue1 = val;
                        setState(() {});
                      },
                    ),
                    new Text(
                      'turkish'.tr().toString(),
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: 1,
                      groupValue: _radioValue1,
                      onChanged: (val) {
                        EasyLocalization.of(context).locale =
                            Locale("en", "US");
                        _radioValue1 = val;
                        setState(() {});
                      },
                    ),
                    new Text(
                      'english'.tr().toString(),
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
