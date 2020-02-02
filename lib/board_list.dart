import 'dart:ui';

import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'itemList.dart';
import 'package:flutter/material.dart' as prefix1;
import 'dart:ui' as prefix0;


class MainList extends StatefulWidget {
  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {

  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);


  int _currentIndex = 0;

  List<Widget> pages;

  String title = "어디아포?";

  // about post
  String _postImage =
      "https://cdn.pixabay.com/photo/2019/10/25/06/07/sky-4576072_960_720.jpg";
  String username = "전주 수병원 봉황세";

  PageController pageController;

  // pageview index
  int selectedPage = 0;

  // dark mode / normal mode
  bool darkMode = false;

  // color
  Color _backgroundColor = Colors.white;
  Color _widgetColor = Colors.black;
  Color _cardBackgroundColor = Colors.black12;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _definePages();
    return Scaffold(
      body: pages[_currentIndex],

    );
  }

  _definePages() {
    pages = [
      // first page
      Container(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: pageController,
          children: <Widget>[
            // first page
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              color: _backgroundColor,
              child: CustomScrollView(
                slivers: <Widget>[
                  // appbar
                  SliverAppBar(
                    backgroundColor: _backgroundColor,
                    //
                    leading: Icon(
                      FontAwesomeIcons.camera,
                      size: 24.0,
                      color: _widgetColor,
                    ),
                    //
                    centerTitle: true,
                    title: Text(
                      title,
                      style: TextStyle(
                          fontSize: 24.0,
                          color: _widgetColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: "BeautyMountainsPersonalUse"),
                    ),
                    //
                    actions: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            // on clicked event => change color // darkmode, normalmode
                            darkMode = !darkMode;
                            // TODO
                            _backgroundColor =
                            darkMode ? Colors.black : Colors.white;
                            _widgetColor =
                            darkMode ? Colors.white : Colors.black;
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.paperPlane,
                          size: 24.0,
                          color: _widgetColor,
                        ),
                      ),
                    ],
                  ),



                  // main
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int idx) {
                          return Container(

                            margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
                            height: 470.0,
                            child: Column(

                              children: <Widget>[

                                //writer info
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            margin:
                                            EdgeInsets.only(right: 8.0),
                                            height: 40.0,
                                            width: 40.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.pink,
                                                      Colors.deepOrange
                                                    ],
                                                    begin:
                                                    Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            child: Container(
                                              margin: EdgeInsets.all(
                                                  2.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1.0),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        itemList[0]
                                                            .image),
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            username,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: _widgetColor,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.more_horiz,
                                            size: 24.0,
                                            color: _widgetColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // image
                                Container(
                                  margin: EdgeInsets.only(top:0, bottom: 8.0),
                                  height: 292.0,
                                  child: Stack(
                                    children: <Widget>[
                                      // shadow image
                                      Positioned(
                                        top: 0,
                                        left: 24.0,
                                        right: 24.0,
                                        bottom: 0,
                                        child: ClipRect(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(16.0),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      _postImage),
                                                  fit: BoxFit.cover),
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 5.0, sigmaY: 5.0),
                                              child: Container(
                                                color: darkMode
                                                    ? Colors.black
                                                    : Colors.white.withOpacity(
                                                    0.8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // real image
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        bottom: 16.0,
                                        child: Container(
                                          padding: EdgeInsets.only(top:16.0, left:16.0, right:16.0, bottom:16.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(16.0),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      _postImage),
                                                  fit: BoxFit.cover)),

                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // text
                                Container(
                                  color: _backgroundColor,
                                  height: 100.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      // icon
                                      Container(
                                        alignment: Alignment.topLeft,
                                        height: 32.0,
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.favorite_border,
                                              size: 24.0,
                                              color: _widgetColor,
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Icon(
                                              Icons.chat_bubble_outline,
                                              size: 24.0,
                                              color: _widgetColor,
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Icon(
                                              FontAwesomeIcons.paperPlane,
                                              size: 24.0,
                                              color: _widgetColor,
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.bookmark_border,
                                              size: 24.0,
                                              color: _widgetColor,
                                            ),
                                          ],
                                        ),
                                      ),

                                      Text(
                                        "2,234 Likes",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: _widgetColor,
                                            fontWeight: FontWeight.w600),
                                      ),

                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: username,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: _widgetColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: "    Hi !!  ",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: _widgetColor,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          TextSpan(
                                            text: "#neonphotoset",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.lightBlueAccent,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }, childCount: 3),
                  ),
                ],
              ),
            ),

            // second page
            Container(), //삭제
          ],
        ),
      ),

      // etc
      Placeholder(),
      Placeholder(
        color: Colors.red,
      ),
      Placeholder(),
      Placeholder(
        color: Colors.red,
      ),
    ];
  }
}