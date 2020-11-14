import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ViewportOffset;

import 'colors.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Home(),
    );
  }
}

@immutable
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      axisDirection: AxisDirection.right,
      controller: _controller,
      physics: PageScrollPhysics(),
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final pageWidth = constraints.maxWidth;
            final pageHeight = constraints.maxHeight;
            position.applyViewportDimension(pageWidth);
            position.applyContentDimensions(0.0, pageWidth * 3);
            return _buildContent(position);
          },
        );
      },
    );
  }

  Widget _buildContent(ViewportOffset position) {
    return SizedBox.expand(
      child: Material(
        child: Ink(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.3),
              radius: 1.0,
              colors: [
                AppColors.backgroundLight,
                AppColors.backgroundDark,
              ],
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        PageHeader(
                          controller: _controller,
                          index: 0,
                          asset: 'assets/images/asset1.png',
                        ),
                        PageHeader(
                          controller: _controller,
                          index: 1,
                          asset: 'assets/images/asset2.png',
                        ),
                        PageHeader(
                          controller: _controller,
                          index: 2,
                          asset: 'assets/images/asset3.png',
                        ),
                        PageHeader(
                          controller: _controller,
                          index: 3,
                          asset: 'assets/images/asset4.png',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    margin: const EdgeInsets.only(bottom: 12.0),
                    alignment: Alignment.centerLeft,
                    child: ProgressIndicator(
                      controller: _controller,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        PageContent(
                          controller: _controller,
                          index: 0,
                        ),
                        PageContent(
                          controller: _controller,
                          index: 1,
                        ),
                        PageContent(
                          controller: _controller,
                          index: 2,
                        ),
                        PageContent(
                          controller: _controller,
                          index: 3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.bottomButtonColor,
                        onPrimary: AppColors.buttonTextColor,
                        minimumSize: Size(0.0, 54.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Build Dashboard Template'),
                          Icon(Icons.add_circle_outline_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.appBarIconColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.menu_rounded,
                        color: AppColors.appBarIconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class PageHeader extends StatelessWidget {
  const PageHeader({
    Key key,
    @required this.controller,
    @required this.index,
    @required this.asset,
  }) : super(key: key);

  final ScrollController controller;
  final int index;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        final pos = controller.position;
        final page = pos.pixels / pos.viewportDimension;
        final value = (1.0 - (page - index).abs()).clamp(0.0, 1.0);
        return Opacity(
          opacity: 0.1 + Curves.easeIn.transform(math.max(0.0, value - 0.1)),
          child: Transform(
            transform: Matrix4.translationValues(
                  (index * pos.viewportDimension - pos.pixels) * 0.65,
                  -25 + (value * 25),
                  0.0,
                ) *
                Matrix4.diagonal3Values(
                  0.5 + (value * 0.5),
                  0.5 + (value * 0.5),
                  1.0,
                ),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FractionallySizedBox(
          alignment: Alignment.bottomLeft,
          widthFactor: 0.7,
          heightFactor: 1.0,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              asset,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class PageContent extends StatelessWidget {
  const PageContent({
    Key key,
    @required this.controller,
    @required this.index,
  }) : super(key: key);

  final ScrollController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        final pos = controller.position;
        return Transform.translate(
          offset: Offset(index * pos.viewportDimension - pos.pixels, 0.0),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sustainability',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Sustainability is the ability to exist constantly. In the 21st century, it refers generally to the capacity for the biosphere and human civilization to co-exist.',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                OnboardingChip(text: 'Compliance Rate'),
                OnboardingChip(text: 'P0 and invoice accuracy'),
                OnboardingChip(text: 'Rate of emergency purchases'),
                OnboardingChip(text: 'Vendor availability'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class OnboardingChip extends StatelessWidget {
  const OnboardingChip({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColors.chipBackground,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }
}

@immutable
class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({
    Key key,
    this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ProgressIndicatorPainter(),
      size: Size(128.0, 24.0),
    );
  }
}

class ProgressIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.pageIndicatorInactive
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(12.0, 12.0),
      Offset(size.width - 12.0, 12.0),
      paint,
    );
    for (int i = 0; i < 4; i++) {
      final offset = ((size.width - 24.0) / 3) * i;
      canvas.drawCircle(Offset(12.0 + offset, 12.0), 4.0, paint);
    }
    paint.color = AppColors.pageIndicatorActive;
    canvas.drawCircle(Offset(12.0, 12.0), 4.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
