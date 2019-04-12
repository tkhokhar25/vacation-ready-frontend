import 'package:flutter/material.dart';
import '../utilities/drawer.dart';
import '../utilities/attractions_user_data.dart';

class SelectInterestSet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SelectInterestSetBody(),
    );
  }
}

final myController = TextEditingController();

class SelectInterestSetBody extends StatefulWidget {
  @override
  _SelectInterestSetBodyState createState() =>
      new _SelectInterestSetBodyState();
}

class _SelectInterestSetBodyState extends State<SelectInterestSetBody> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        drawer: new MyDrawer(),
        appBar: new AppBar(
          title: new Text("vacation ready"),
          backgroundColor: Color.fromRGBO(101, 202, 214, 1.0),
        ),
        body: new Container(
          margin: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 30.0)),
            new Card(
                color: Color.fromRGBO(230, 142, 142, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: GestureDetector(
                    onTap: () {
                      interest_set_id = -1;
                      favoriteCuisines.clear();
                      favoriteAttractions.clear();
                      selectCount = 0;
                      // chooseInterestName(context);
                      Navigator.pushNamed(context, '/cuisines_select');
                    },
                    child: Column(children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 20.0)),
                      new Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image:
                                  new AssetImage('images/interests_types.jpg'),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                          )),
                      new ListTile(
                        leading: Icon(Icons.place),
                        title: Text('Create a new Interest Set'),
                        subtitle:
                            Text('Tell us what you love to do on a trip!'),
                      )
                    ]))),
            new Padding(padding: EdgeInsets.only(bottom: 30.0)),
            new Card(
                color: Color.fromRGBO(230, 142, 142, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: GestureDetector(
                    onTap: () {}, //TODO: change route
                    child: new Column(children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 20.0)),
                      new Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image:
                                  new AssetImage('images/old_interest_set.jpg'),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                          )),
                      new ListTile(
                        leading: Icon(Icons.arrow_back),
                        title: Text('Look at your existing Interest Sets'),
                        subtitle: Text('Somethings are meant to be static!'),
                      )
                    ]))),
          ]),
        ));
  }
}

// void chooseInterestName(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       // return object of type Dialog
//       return new _SystemPadding(child: AlertDialog(
//         title: new Text(
//           "Interest Set Name",
//           style: TextStyle(fontFamily: 'Montserrat'),
//         ),
//         actions: <Widget>[
//           new Row(children: <Widget>[
//             Container(
//               width: 100,
//               height: 100,
//               // padding: EdgeInsets.all(15),
//               child: new FocusScope(
//                   node: new FocusScopeNode(),
//                   child: new TextField(
//                     decoration: InputDecoration(
//                       hintText: "City Name",
//                     ),
//                     controller: myController,
//                   )),
//             ),
//             // usually buttons at the bottom of the dialog
//           ]),
//           Row(
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.only(top: 50),
//                 child: new FlatButton(
//                   child: new Text("Close"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               )
//             ],
//           )
//         ],
//       ));
//     },
//   );
// }