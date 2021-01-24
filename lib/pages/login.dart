import 'package:client/domain/user.dart';
import 'package:client/pages/api.dart';
import 'package:client/pages/register.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';
  User curentUser;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(fontSize: 20)),
                            controller: emailController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Email cannot be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(fontSize: 20)),
                            controller: passwordController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Password cannot be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('New user?'),
                                FlatButton(
                                    child: Text(
                                      'SingUp',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Register()));
                                    })
                              ]),
                          OutlineButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  var email = emailController.text;
                                  var password = passwordController.text;
                                  setState(() {
                                    message = 'please wait...';
                                  });
                                  var rsp = await loginUser(email, password);
                                  print(rsp);

                                  if (rsp['id'] == null) {
                                    setState(() {
                                      Flushbar(
                                        title: "Login Failed",
                                        message: rsp['message'],
                                        duration: Duration(seconds: 5),
                                      ).show(context);
                                    });
                                  } else {
                                    curentUser = User.fromJson(rsp);
                                    curentUser.password=passwordController.text;
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return HomePage(userLogin: curentUser);
                                    }));
                                  }
                                }
                              },
                              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                              borderSide: BorderSide(width: 2.0, color: Colors.blue),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)),
                              child: Text("Log in")),
                          SizedBox(height: 10),
                        ],
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
