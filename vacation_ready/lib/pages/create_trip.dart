import 'package:flutter/material.dart';
import '../utilities/drawer.dart';

class CreateTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CreateTripBody(),
    );
  }
}

class CreateTripBody extends StatefulWidget {
  @override
  _CreateTripBodyState createState() => new _CreateTripBodyState();
}

class _CreateTripBodyState extends State<CreateTripBody> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
              
                color: Color.fromRGBO(162, 228, 236, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/select_interest_set');
                  },
                  child: Column(children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 20.0)),
                  new Container(
                      height: 130.0,
                      width: 130.0,
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: new AssetImage('images/plan_trip.jpg'),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      )),
                  new ListTile(
                    leading: Icon(Icons.place),
                    title: Text('Plan a Trip'),
                    subtitle: Text('Get started with your all new experience'),
                  )
                ]))),
            new Padding(padding: EdgeInsets.only(bottom: 30.0)),
            new Card(
                color: Color.fromRGBO(162, 228, 236, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: GestureDetector(
                  onTap: () { 
                    Navigator.pushNamed(context, '/search-similar_trip');
                  },//TODO: change route
                  child: new Column(children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 20.0)),
                  new Container(
                      height: 130.0,
                      width: 130.0,
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: new AssetImage('images/resume_planning.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      )),
                  new ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text('Find Top places for your Destination'),
                    subtitle: Text('Resume from where you stopped'),
                  )
                ]))),
          ]),
        ));
  }
}
