import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'dart:ui' as prefix0;
import '../itemList.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Color _backgroundColor = Colors.white;
  Color _widgetColor = Colors.black;

  // dark mode / normal mode
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }


  Widget _buildBody() {
    return Container(
      color: _backgroundColor,
      child: CustomScrollView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
// appbar
          SliverAppBar(
            backgroundColor: _backgroundColor,
            leading: Icon(
              Icons.arrow_back_ios,
              size: 24.0,
              color: _widgetColor,
            ),
            title: Text(
              "Velo.sid",
              style: prefix1.TextStyle(
                  fontSize: 32.0,
                  color: _widgetColor,
                  fontWeight: FontWeight.w600),
            ),
            actions: <Widget>[
              Icon(
                Icons.more_vert,
                size: 24.0,
                color: _widgetColor,
              ),
            ],
          ),

// divider
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              height: 2.0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: darkMode
                          ? [
                        Colors.black,
                        Colors.grey[700],
                        Colors.black
                      ]
                          : [
                        Colors.white,
                        Colors.grey[300],
                        Colors.white
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
            ),
          ),

// profile
          SliverToBoxAdapter(
            child: Container(
              height: 300.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
// posts & follower
                  Container(
                    height: 80.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
// profile image
                        Container(
                          margin: EdgeInsets.only(right: 32.0),
                          height: 72.0,
                          width: 72.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                  NetworkImage(itemList[0].image),
                                  fit: BoxFit.fill)),
                        ),

                        Container(
                          padding:
                          EdgeInsets.only(right: 32.0, bottom: 4.0),
                          width:
                          MediaQuery
                              .of(context)
                              .size
                              .width - 104.0,
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "11.8K",
                                            style: prefix1.TextStyle(
                                                fontSize: 16.0,
                                                color: _widgetColor,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            "posts",
                                            style: prefix1.TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey,
                                                fontWeight:
                                                FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "198K",
                                            style: prefix1.TextStyle(
                                                fontSize: 16.0,
                                                color: _widgetColor,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            "Follwers",
                                            style: prefix1.TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey,
                                                fontWeight:
                                                FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "1309",
                                            style: prefix1.TextStyle(
                                                fontSize: 16.0,
                                                color: _widgetColor,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            "Followers",
                                            style: prefix1.TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.grey,
                                                fontWeight:
                                                FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Row(
                                  children: <Widget>[
// 3 btns
// message btn
                                    Flexible(
                                      flex: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.only(
                                              topLeft:
                                              Radius.circular(
                                                  48.0),
                                              bottomLeft:
                                              Radius.circular(
                                                  48.0)),
                                          border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0),
                                        ),
                                        child: Center(
                                            child: Text(
                                              "Message",
                                              style: prefix1.TextStyle(
                                                  fontSize: 12.0,
                                                  color: _widgetColor,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            )),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 4.0,
                                    ),

// user btn
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0),
                                        ),
                                        child: Center(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.check,
                                                size: 16.0,
                                                color: Colors.grey,
                                              ),
                                              Icon(
                                                Icons.person_outline,
                                                size: 16.0,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 4.0,
                                    ),

// arrow btn
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.only(
                                              topRight:
                                              Radius.circular(
                                                  48.0),
                                              bottomRight:
                                              Radius.circular(
                                                  48.0)),
                                          border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            size: 16.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

// text
                  Container(
                    padding: EdgeInsets.all(12.0),
                    height: 150.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "International Photograph 🌎",
                          style: prefix1.TextStyle(
                              fontSize: 14.0,
                              color: _widgetColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Personal Blog",
                          style: prefix1.TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Valentina sidious".toUpperCase(),
                          style: prefix1.TextStyle(
                              fontSize: 14.0,
                              color: _widgetColor,
                              fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 220.0,
                              child: Text(
                                "🧡 France, Paris / 💛 USA, California"
                                    .toUpperCase(),
                                style: prefix1.TextStyle(
                                    fontSize: 14.0,
                                    color: _widgetColor,
                                    fontWeight: FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "more",
                              style: prefix1.TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Text(
                          "See translation".toUpperCase(),
                          style: prefix1.TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "instagram.com/p/BjaCQ3qh9WQ/",
                          style: prefix1.TextStyle(
                              fontSize: 14.0,
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.w400),
                        ),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Followed by ",
                              style: prefix1.TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: "jerreny.kimmell, jimmy.callens ",
                              style: prefix1.TextStyle(
                                  fontSize: 12.0,
                                  color: _widgetColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: "and ",
                              style: prefix1.TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: "robert_downney.jr",
                              style: prefix1.TextStyle(
                                  fontSize: 12.0,
                                  color: _widgetColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),

// saved story
                  Container(
                    margin: EdgeInsets.only(left: 24.0),
                    height: 70.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 24.0),
                          height: 70.0,
                          width: 50.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            itemList[1].image),
                                        fit: BoxFit.fill)),
                              ),
                              Text(
                                "#pro...",
                                style: prefix1.TextStyle(
                                    fontSize: 14.0,
                                    color: _widgetColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 24.0),
                          height: 70.0,
                          width: 50.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            itemList[2].image),
                                        fit: BoxFit.fill)),
                              ),
                              Text(
                                "💘💡",
                                style: prefix1.TextStyle(
                                    fontSize: 14.0,
                                    color: _widgetColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 24.0),
                          height: 70.0,
                          width: 50.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            itemList[3].image),
                                        fit: BoxFit.fill)),
                              ),
                              Text(
                                "⚽🏀",
                                style: prefix1.TextStyle(
                                    fontSize: 14.0,
                                    color: _widgetColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

// tabbar
          SliverToBoxAdapter(
            child: Container(
              height: 64.0,
              color: darkMode ? Colors.black12 : Colors.grey[100],
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Center(
                        child: Icon(
                          Icons.dialpad,
                          size: 24.0,
                          color: Colors.lightBlueAccent,
                        )),
                  ),
                  Flexible(
                    child: Center(
                        child: Icon(
                          Icons.menu,
                          size: 24.0,
                          color: Colors.grey,
                        )),
                  ),
                  Flexible(
                    child: Center(
                        child: Icon(
                          Icons.remove_circle_outline,
                          size: 24.0,
                          color: Colors.grey,
                        )),
                  ),
                  Flexible(
                    child: Center(
                        child: Icon(
                          Icons.crop_square,
                          size: 24.0,
                          color: Colors.grey,
                        )),
                  ),
                ],
              ),
            ),
          ),

// gridview
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0),
            delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                itemList[index % 5].image),
                            fit: BoxFit.fill)),
                  );
                }),
          )
        ],
      ),
    );
  }

}