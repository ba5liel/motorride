import 'package:flutter/material.dart';

class RequestLoading extends StatefulWidget {
  RequestLoading({Key key}) : super(key: key);

  @override
  _RequestLoadingState createState() => _RequestLoadingState();
}

class _RequestLoadingState extends State<RequestLoading>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: AnimatedBuilder(
        animation:
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildContainer(100 * _controller.value),
              _buildContainer(200 * _controller.value),
              _buildContainer(300 * _controller.value),
              _buildContainer(400 * _controller.value),
              _buildContainer(500 * _controller.value),
              Align(child: Text("Requesting Driver")),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContainer(double radius) {
    return ClipRRect(
      //clipper: ,
      borderRadius: BorderRadius.circular(500),
      child: Transform.scale(
        scale: 2.3,
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(1 - _controller.value),
          ),
        ),
      ),
    );
  }
}
