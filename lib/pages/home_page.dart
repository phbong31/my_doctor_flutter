import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('어디아포',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                '어디아포에 오신 것을 환영합니다',
                style: TextStyle(fontSize: 24.0),
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              Text('어디아포에 오신 것을 환영합니다'),
              Padding(padding: EdgeInsets.all(8.0)),
              SizedBox(
                width: 260.0,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 88.0,
                        height: 88.0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'http://hsbong.synology.me:8080/profile/bong.png'),
                        ),
                      ),
                      Text(
                        'bonghwangse@gmail.com',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('봉황세'),
                      Padding(padding: EdgeInsets.all(8.0)),
                      RaisedButton(
                        child: Text('팔로우'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
