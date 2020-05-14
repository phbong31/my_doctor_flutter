import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_doctor/pages/splash_page.dart';
import 'dart:convert';
import 'package:my_doctor/utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  static final String routeName = 'register_page';
  String _name;
  String _email;
  String _password;
  String _url;
  String _phoneNumber;
  String _calories;
  String _birth;
  String _uuid;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> signUp(String name, phone, birth, uuid) async {
    Map data = {
      'name': name,
      'phone': phone,
      'birth' : birth,
      'sex' : '',
      'uuid' : uuid
    };

    var jsonResponse = null;
    var response = await http.post(Constants.SIGNUP_URL, body: data);
    if(response.statusCode == 200) {
      print('200');
      print(response.body);
      jsonResponse = json.decode(response.body);
      print(jsonResponse["result"]);
      int result = jsonResponse["result"];
      if(jsonResponse != null && result > 0) {
        print('navigator');
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SplashScreen()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }


  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: '성함'),
      maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  Widget _builURL() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Url'),
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _url = value;
      },
    );
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: '핸드폰 번호 (숫자만)'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _url = value;
      },
    );
  }

  Widget _buildBirth() {
    return TextFormField(
      decoration: InputDecoration(labelText: '생년월일 (YYMMDD)'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        int calories = int.tryParse(value);

        if (calories == null || calories <= 0) {
          return 'Calories must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        _calories = value;
      },
    );
  }

  Widget headerSection() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text("어디아포",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
          margin: EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Text("회원가입을 위해 정보 입력이 필요합니다",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("가입하기")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                headerSection(),
                _buildName(),
//              _buildEmail(),
//              _buildPassword(),
//              _builURL(),
                _buildPhoneNumber(),
                _buildBirth(),
                SizedBox(height: 100),
                RaisedButton(
                  child: Text(
                    '확인',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();

                    _uuid = '00';
                    signUp(_name, _phoneNumber, _birth, _uuid);

//                    print(_name);
//                    print(_email);
//                    print(_phoneNumber);
//                    print(_url);
//                    print(_password);
//                    print(_calories);

                    //Send to API
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
