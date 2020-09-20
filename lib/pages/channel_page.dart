import 'package:flutter/material.dart';
import 'package:my_doctor/model/providers.dart';
import 'package:my_doctor/widgets/channel_main.dart';
import 'package:my_doctor/widgets/channel_write.dart';
import 'package:my_doctor/widgets/channel_dialog.dart';
import 'package:provider/provider.dart';

// final globalScaffoldKey = GlobalKey<ScaffoldState>();

class ChannelPage extends StatefulWidget {
  static final String routeName = 'channel_page';
  final String channelId;
  ChannelPage({Key key, @required this.channelId}) : super(key: key);

  @override
  _ChannelPageState createState() => _ChannelPageState();

}

class _ChannelPageState extends State<ChannelPage> {

  int _selectedIndex = 0;
  List _pages = [ChannelMain(), ChannelInfo(),ChannelWrite()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inputData = Provider.of<ProviderData>(context);

    //Provider에 그룹아이디 저장
    inputData.setGroupId(widget.channelId);

    return Scaffold(
      // key: globalScaffoldKey,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context,
                bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: true,
                  pinned: true,
//                  snap: true,
                  flexibleSpace: GestureDetector(
                    onTap: () {
                      ChannelDialog.customDialog(context);
                    },
                    child: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('봉황세',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white)),
                            SizedBox(width: 8.0),
                            Text('(전주 수병원 정형외과 전문의)',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.blue[100])),
                          ],
                        ),
                        background: Image.network(
                          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      onTap: _onItemTapped,
                      tabs: [
                        Tab(icon: Icon(Icons.home), text: "채널홈"),
                        Tab(icon: Icon(Icons.info), text: "진료 안내"),
                        Tab(icon: Icon(Icons.add_comment), text: "글쓰기"),
                      ],
                    ),
                  ),
                  pinned: true,
//                floating: false,
                ),

              ];
            },

            body: Center(
              child: _pages[_selectedIndex]
            )
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
// void showSnackbarGlobal(String message) {
//   var currentScaffold = globalScaffoldKey.currentState;
//   currentScaffold.hideCurrentSnackBar(); // If there is a snackbar visible, hide it before the new one is shown.
//   currentScaffold.showSnackBar(SnackBar(content: Text(message)));
// }

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.blue[50],
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class ChannelInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inputData = Provider.of<ProviderData>(context, listen: false);
    return Container(
      child :Center(
        child : Text('그룹아이디 : ${inputData.groupId}')
      )
    );
  }
}
