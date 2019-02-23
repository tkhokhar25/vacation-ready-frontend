// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

enum GridDemoTileStyle {
  twoLine
}

typedef BannerTapCallback = void Function(Photo photo);

const double _kMinFlingVelocity = 800.0;
const String _kGalleryAssetsPackage = '../res';

class Photo {
  Photo({
    this.assetName,
    this.assetPackage,
    this.title,
    this.caption,
    this.isFavorite = false,
  });

  final String assetName;
  final String assetPackage;
  final String title;
  final String caption;

  bool isFavorite;
  String get tag => assetName; // Assuming that all asset names are unique.

  bool get isValid => assetName != null && title != null && isFavorite != null;
}

class GridPhotoViewer extends StatefulWidget {
  const GridPhotoViewer({ Key key, this.photo }) : super(key: key);

  final Photo photo;

  @override
  _GridPhotoViewerState createState() => _GridPhotoViewerState();
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text),
    );
  }
}

class _GridPhotoViewerState extends State<GridPhotoViewer> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
    return Offset(offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity)
      return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = _controller.drive(Tween<Offset>(
      begin: _offset,
      end: _clampOffset(_offset + direction * distance)
    ));
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: ClipRect(
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
          child: Image.asset(
            widget.photo.assetName,
            package: widget.photo.assetPackage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
class OptionTiles extends StatefulWidget {
  final Photo photo;
  final GridDemoTileStyle tileStyle;
  final BannerTapCallback onBannerTap; // User
  double myBorderRadius = 10.0;
  double myBorderWidth = 0.0;
  double isSelected = 0.7;

  OptionTiles({
    Key key,
    @required this.photo,
    @required this.tileStyle,
    @required this.onBannerTap
  }) : assert(photo != null && photo.isValid),
       assert(tileStyle != null),
       assert(onBannerTap != null),
       super(key: key);

  @override
  _OptionTilesState createState() => new _OptionTilesState();
}


class _OptionTilesState extends State<OptionTiles> {
  @override
  Widget build(BuildContext context) {
    final Widget image = GestureDetector(
      child: Hero(
        key: Key(widget.photo.assetName),
        tag: widget.photo.tag,
        child: Image.asset(
          widget.photo.assetName,
          package: widget.photo.assetPackage,
          fit: BoxFit.cover,
        )
      )
    );

    switch (widget.tileStyle) {
      case GridDemoTileStyle.twoLine:
        return GridTile(
          footer: GestureDetector(
            child: GridTileBar(
              title: _GridTitleText(widget.photo.title),
            ),
          ),
          child: GestureDetector(
            child: Container(
              child: new ClipRRect(
              borderRadius: new BorderRadius.circular(widget.myBorderRadius),
              child: Opacity(
                opacity: widget.isSelected,
                child: image,
              ) 
              ),
              // decoration: BoxDecoration(border: Border.all(color: Color.fromRGBO(89, 208, 255, 1.0), width: widget.myBorderWidth), 
              //                           borderRadius: BorderRadius.circular(widget.myBorderRadius)),
            ),
            onTap: () {
              setState(() {
                  if (widget.isSelected == 0.7){
                    widget.isSelected = 1.0;
                  }else {
                    widget.isSelected = 0.7;
                  }
              });      
            },
          )
          );
    }
    assert(widget.tileStyle != null);
    return null;
  }
}

class GridListDemo extends StatefulWidget {
  const GridListDemo({ Key key }) : super(key: key);

  static const String routeName = 'interest-create';

  @override
  GridListDemoState createState() => GridListDemoState();
}

class GridListDemoState extends State<GridListDemo> {
  GridDemoTileStyle _tileStyle = GridDemoTileStyle.twoLine;

  List<Photo> photos = <Photo>[
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Chennai',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Pondicherry',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Chennai',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Chettinad',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Chettinad',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Tanjore',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Pondicherry',
    ),
    Photo(
      assetName: 'chinese.jpg',
      assetPackage: _kGalleryAssetsPackage,
      title: 'Pondicherry',
    ),
  ];

  void changeTileStyle(GridDemoTileStyle value) {
    setState(() {
      _tileStyle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 55.0,left: 20.0,bottom: 15.0), 
            child: Opacity(
              opacity: 1.0,
              child: Text(
              'What are your favorite cuisines ?',
              textAlign: TextAlign.left,
              style:TextStyle(fontFamily: 'Montserrat', fontSize: 26),
              )
            )   
          ),

          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 3 : 3,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                padding: const EdgeInsets.all(20.0),
                childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
                children: photos.map<Widget>((Photo photo) {
                  return OptionTiles(                  
                    photo: photo,
                    tileStyle: _tileStyle,
                    onBannerTap: (Photo photo) {
                      setState(() {

                      });
                    }
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}