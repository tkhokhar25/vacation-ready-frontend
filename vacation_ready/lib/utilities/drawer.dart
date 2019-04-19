import 'package:flutter/material.dart';
import '../utilities/user_info.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail: new Text(email),
                accountName: new Text(userName),
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('images/drawer_background.jpg')
                  )
                )
              ),
              new ListTile(
                title: new Text("Plan"),
                trailing: new Icon(Icons.grid_on),
                onTap: () => Navigator.of(context).pushNamed('/select_interest_set')
              ),
              new Divider(),
              
              new ListTile(
                title: new Text("Logout"),
              )
              ],
          )
        );
  }
}