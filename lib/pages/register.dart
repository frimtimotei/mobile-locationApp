import 'package:client/domain/user.dart';
import 'package:client/pages/api.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String message = '';
  User curentUser;
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0, iconTheme: IconThemeData(color: Colors.black)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(fontSize: 20)),
                        controller: firstNameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'First Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: TextStyle(fontSize: 20)),
                        controller: lastNameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Last Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
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

                      OutlineButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              var firstName= firstNameController.text;
                              var lastName=lastNameController.text;
                              var email = emailController.text;
                              var password = passwordController.text;
                              setState(() {
                                message = 'please wait...';
                              });
                              var rsp = await registerUser(firstName, lastName, email, password);
                              print(rsp);
                              if (rsp['id'] == null) {
                                setState(() {
                                  Flushbar(
                                              title: "Registration Failed",
                                                message: rsp['message'],
                                               duration: Duration(seconds: 5),
                                  ).show(context);
                                });
                              } else {
                                curentUser=User.fromJson(rsp);
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
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          child: Text("Register")),

                      SizedBox(height: 10),

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

