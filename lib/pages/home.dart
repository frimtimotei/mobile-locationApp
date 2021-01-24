import 'package:client/domain/user.dart';
import 'package:client/pages/api.dart';
import 'package:client/pages/login.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';


// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  User userLogin;
  Position currentPosition;
  String message = '';

  HomePage({this.userLogin});

  @override
  Widget build(BuildContext context) {
    if (userLogin == null)
      return Login();
    else
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Home"),
            backgroundColor: Colors.blue[300],
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person, color: Colors.white),
                label: Text("logout", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  this.userLogin = null;
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Login();
                  }));
                },
              ),
            ],
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Hello " + userLogin.firstName,
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 30),
              OutlineButton(
                child: Text("Send location"),
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                borderSide: BorderSide(width: 2.0, color: Colors.blue),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () async {
                  this.message = "Wait...";
                  currentPosition = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);

                  var rsp = await sendLocation(
                      currentPosition.latitude.toString(),
                      currentPosition.longitude.toString(),
                      userLogin);
                  if (rsp != null) {
                    Flushbar(
                      title: "Location Sent",
                      message: "Your current location has been sent",
                      duration: Duration(seconds: 5),
                    ).show(context);
                  } else {
                    Flushbar(
                      title: "Error",
                      message: "Can't send location",
                      duration: Duration(seconds: 5),
                    ).show(context);
                  }
                  message = "";
                },
              ),
              SizedBox(height: 20),
              Text("Automatically send location"),

              SizedBox(height: 20),
                LiteRollingSwitch(
                //initial value
                value: false,
                textOn: 'active',
                textOff: 'inactive',
                colorOn: Colors.greenAccent[700],
                colorOff: Colors.redAccent[700],
                iconOn: Icons.done,
                iconOff: Icons.remove_circle_outline,
                textSize: 16.0,
                onChanged: (bool state) async {


                    if (state == false)
                      return;
                    else {
                      currentPosition = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);

                      sendLocaionAut(currentPosition.longitude.toString(),
                          currentPosition.latitude.toString(), userLogin,
                          state);
                    }







                }
              ),

            ],
          )));
  }
}
