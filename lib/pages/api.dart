import 'package:client/domain/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';


Future loginUser(String email, String password) async {
  final Map<String, dynamic> loginData = {

    'email': email,
    'password': password

  };
  String url='http://10.0.2.2:8080/users/login';
  final response = await http.post(url,headers: {'Content-Type': 'application/json',"accept" : "application/json" },
      body: json.encode(loginData));

  var convertDataJason= jsonDecode(response.body);
  return convertDataJason;
}

Future registerUser(String firstName, String lastName, String email, String password) async {
  final Map<String, dynamic> loginData = {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password

  };
  String url='http://10.0.2.2:8080/users/register';
  final response = await http.post(url,headers: {'Content-Type': 'application/json',"accept" : "application/json" },
      body: json.encode(loginData));

  var convertDataJason= jsonDecode(response.body);
  return convertDataJason;
}

Future sendLocation(String latitude, String longitude,User user) async {
  final Map<String, dynamic> loginData = {
    'latitude': latitude,
    'longitude': longitude,


  };
  String url='http://10.0.2.2:8080/locations/create';
  String email = user.email;
  String password = user.password;
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$email:$password'));


  final response = await http.post(url,headers: <String, String>{'Content-Type': 'application/json',"accept" : "application/json",'authorization': basicAuth},body: json.encode(loginData));
if(response.statusCode==200){
  var convertDataJason= jsonDecode(response.body);
  return convertDataJason;}
 else
   return null;
}

void sendLocaionAut(String latitude, String longitude,User user, bool activ) async
{ if(activ==false)
  return;
else {
  for(var i=1; i<=3;i++){
    var rsp = await sendLocation(latitude,longitude, user);
    print(rsp);
    await Future.delayed(const Duration(seconds: 20), () {});
  }
}
}


