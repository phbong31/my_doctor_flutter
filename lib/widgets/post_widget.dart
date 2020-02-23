import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_doctor/model/board_base.dart';
import 'package:my_doctor/model/photo.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:my_doctor/utils/ui_utils.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'avartar_widget.dart';


class PostWidget extends StatefulWidget {
  final BoardBase post;
  final User userInfo;
  final List<Photo> photos;
  final String token;

  PostWidget(this.post, this.userInfo, this.photos, this.token);


  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final StreamController<void> _doubleTapImageEvents =
  StreamController.broadcast();
  bool _isSaved = false;
  int _currentImageIndex = 0;


  @override
  void dispose() {
    _doubleTapImageEvents.close();
    super.dispose();
  }

  void _updateImageIndex(int index) {
    setState(() => _currentImageIndex = index);
  }
//
//  void _onDoubleTapLikePhoto() {
//    setState(() => widget.post.addLikeIfUnlikedFor(currentUser));
//    _doubleTapImageEvents.sink.add(null);
//  }
//
//  void _toggleIsLiked() {
//    setState(() => widget.post.toggleLikeFor(currentUser));
//  }
//
//  void _toggleIsSaved() {
//    setState(() => _isSaved = !_isSaved);
//  }
//
//  void _showAddCommentModal() {
//    showModalBottomSheet(
//      context: context,
//      builder: (BuildContext context) {
//        return Padding(
//          padding:
//          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//          child: AddCommentModal(
//            user: currentUser,
//            onPost: (String text) {
//              setState(() {
//                widget.post.comments.add(Comment(
//                  text: text,
//                  user: currentUser,
//                  commentedAt: DateTime.now(),
//                  likes: [],
//                ));
//              });
//              Navigator.pop(context);
//            },
//          ),
//        );
//      },
//    );
//  }

  @override
  Widget build(BuildContext context) {
//    var photoObjsJson = jsonDecode(widget.post.photoList)['photos'] as List;
//    List<Photo> photoObjs = photoObjsJson.map((photoJson) => Photo.fromJson(photoJson)).toList();
//    print(widget.token);
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // User Details

        Row(
          children: <Widget>[
            AvatarWidget(user: widget.userInfo, isLarge: false),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.post.writerName, style: bold),
                if (widget.post.position != null) Text(widget.post.position)
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => showSnackbar(context, 'More'),
            )
          ],
        ),

        //text
        Padding(
          padding: const EdgeInsets.only(left:12.0, top:8.0, right:8.0, bottom:12.0),
          child: Column(
            children: <Widget>[
              Text(widget.post.text),
            ],
          ),
        ),
//         Photo Carosuel

        GestureDetector(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              widget.photos != null ?
              CarouselSlider(

                items: widget.photos.map((json) {
//                  return CachedNetworkImage(
//                    imageUrl: Constants.PHOTO_VIEW_URL + json.photoId.toString() + "?token="+widget.token+"/",
//                    fit: BoxFit.fitWidth,
//                    width: MediaQuery.of(context).size.width,
//                  );
//                try {
//                print(Constants.PHOTO_VIEW_URL + json.photoId.toString() + "?token="+widget.token);
                  return CachedNetworkImage(
                    imageUrl:Constants.PHOTO_VIEW_URL + json.photoId.toString() + "?token="+widget.token,
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  );
//                } catch (e) {
//                  print('ShowImage - _renderImage()] - caught exception $e');
//                  return Center(
//                    child: Text('Image Format Can Not Be Rendered'),
//                  );
//                }

                }).toList(),
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                onPageChanged: _updateImageIndex,
              ) : Container(),
//              HeartOverlayAnimator(
//                  triggerAnimationStream: _doubleTapImageEvents.stream),
            ],
          ),
//          onDoubleTap: _onDoubleTapLikePhoto,
        ),
         //Action Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: HeartIconAnimator(
//                isLiked: widget.post.isLikedBy(currentUser),
//                size: 28.0,
//                onTap: _toggleIsLiked,
//                triggerAnimationStream: _doubleTapImageEvents.stream,
//              ),
//            ),
            IconButton(
              padding: EdgeInsets.zero,
              iconSize: 28.0,
              icon: Icon(Icons.chat_bubble_outline),
//              onPressed: _showAddCommentModal,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              iconSize: 28.0,
              icon: Icon(OMIcons.nearMe),
              onPressed: () => showSnackbar(context, 'Share'),
            ),
            Spacer(),
            widget.photos != null ?
              PhotoCarouselIndicator(
                photoCount: widget.photos.length,
                activePhotoIndex: _currentImageIndex,
              ):Container(),
            Spacer(),
            Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              iconSize: 28.0,
              icon:
              _isSaved ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),
//              onPressed: _toggleIsSaved,
            )
          ],
        ),


        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              // Liked by
//              if (widget.post.likes.isNotEmpty)
//                Padding(
//                  padding: const EdgeInsets.only(bottom: 8.0),
//                  child: Row(
//                    children: <Widget>[
//                      Text('Liked by '),
//                      Text(widget.post.likes[0].user.name, style: bold),
//                      if (widget.post.likes.length > 1) ...[
//                        Text(' and'),
//                        Text(' ${widget.post.likes.length - 1} others',
//                            style: bold),
//                      ]
//                    ],
//                  ),
//                ),
//              // Comments
////              if (widget.post.comments.isNotEmpty)
////                Padding(
////                  padding: const EdgeInsets.only(bottom: 4.0),
////                  child: Column(
////                    children: widget.post.comments
////                        .map((Comment c) => CommentWidget(c))
////                        .toList(),
////                  ),
////                ),
////              // Add a comment...
//              Row(
//                children: <Widget>[
//                  AvatarWidget(
//                    user: currentUser,
//                    padding: EdgeInsets.only(right: 8.0),
//                  ),
//                  GestureDetector(
//                    child: Text(
//                      'Add a comment...',
//                      style: TextStyle(color: Colors.grey),
//                    ),
////                    onTap: _showAddCommentModal,
//                  ),
//                ],
//              ),
//              // Posted Timestamp
//              Text(
//                widget.post.createdTime,
//                style: TextStyle(color: Colors.grey, fontSize: 11.0),
//              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: <Widget>[
                  Text("답글 "+widget.post.replyCount.toString()+"개")
                ],),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PhotoCarouselIndicator extends StatelessWidget {
  final int photoCount;
  final int activePhotoIndex;

  PhotoCarouselIndicator({
    @required this.photoCount,
    @required this.activePhotoIndex,
  });

  Widget _buildDot({bool isActive}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: isActive ? 7.5 : 6.0,
          width: isActive ? 7.5 : 6.0,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(photoCount, (i) => i)
          .map((i) => _buildDot(isActive: i == activePhotoIndex))
          .toList(),
    );
  }
}

//class AddCommentModal extends StatefulWidget {
//  final User user;
//  final ValueChanged<String> onPost;
//
//  AddCommentModal({@required this.user, @required this.onPost});
//
//  @override
//  _AddCommentModalState createState() => _AddCommentModalState();
//}

//class _AddCommentModalState extends State<AddCommentModal> {
//  final _textController = TextEditingController();
//  bool _canPost = false;
//
//  @override
//  void initState() {
//    _textController.addListener(() {
//      setState(() => _canPost = _textController.text.isNotEmpty);
//    });
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    _textController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Row(
//      children: <Widget>[
//        AvatarWidget(user: widget.user),
//        Expanded(
//          child: TextField(
//            controller: _textController,
//            autofocus: true,
//            decoration: InputDecoration(
//              hintText: 'Add a comment...',
//              border: InputBorder.none,
//            ),
//          ),
//        ),
//        FlatButton(
//          child: Opacity(
//            opacity: _canPost ? 1.0 : 0.4,
//            child: Text('Post', style: TextStyle(color: Colors.blue)),
//          ),
//          onPressed:
//          _canPost ? () => widget.onPost(_textController.text) : null,
//        )
//      ],
//    );
//  }
//}