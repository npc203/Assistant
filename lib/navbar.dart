import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Sam'),
            accountEmail: Text('samjerub@gmail.com'),
            currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/empty_avatar.png')),
          ),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              if (ModalRoute.of(context).settings.name != '/') {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/', arguments: true);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            title: Text("Random Task"),
            leading: Icon(Icons.account_balance_wallet),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/task');
            },
          ),
          ListTile(
            title: Text("Add Task"),
            leading: Icon(Icons.add_circle),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/Add');
            },
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            title: Text("Exit"),
            leading: Icon(Icons.close),
            onTap: () => SystemNavigator.pop(),
          ),
        ]),
      ),
    );
  }
}
