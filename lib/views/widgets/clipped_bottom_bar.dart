part of 'widgets.dart';

Animation<double> _animationClipper;

class ClippedBottomBar extends StatefulWidget {
  List<ClippedBottomBarItem> items;
  Function(int index) onTap;
  int index;

  ClippedBottomBar({
    @required this.items,
    this.onTap,
    this.index,
  });

  @override
  _ClippedBottomBarState createState() => _ClippedBottomBarState();
}

class _ClippedBottomBarState extends State<ClippedBottomBar> with TickerProviderStateMixin {
  AnimationController _controllerClipper;
  List<AnimationController> _animationControllers;

  List<Animation<double>> _animationIconCircles;
  List<Animation<double>> _animations;

  int _previousIndex;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.index;
    _animations = List.generate(widget.items.length, (index) => null);
    _animationIconCircles = List.generate(widget.items.length, (index) => null);

    _animationControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _controllerClipper = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animations[widget.index] = Tween<double>(begin: 0.0, end: 1.0).animate(_animationControllers[widget.index]);
    _animationIconCircles[widget.index] = Tween<double>(begin: -1.5, end: 1.0).animate(_animationControllers[widget.index]);
    _animationControllers[widget.index].forward();
  }

  @override
  void dispose() {
    _controllerClipper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<BottomNavigationBloc, BottomNavigationState>(
      listener: (_, stateBottomNavigation) {
        if (stateBottomNavigation is BottomNavigationResult) {
          _animateClipper(context, stateBottomNavigation.currentNav);
        }
      },
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: Stack(
            children: [
              CustomPaint(
                painter: BottomBarPainter(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widget.items.map((item) {
                      var index = widget.items.indexOf(item);

                      return AnimatedBuilder(
                        animation: _animationControllers[index],
                        builder: (_, child) {
                          return Transform(
                            transform: Matrix4.translationValues(0.0, -30.0 * (_animations[index] != null ? _animations[index].value : 0.0), 0.0),
                            child: child,
                          );
                        },
                        child: Icon(item.icon),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.translationValues((_animationClipper != null ? _animationClipper.value : size.width / 2 - 35) + 10, -30, 0.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.items.map((item) {
                  int index = widget.items.indexOf(item);

                  return AnimatedBuilder(
                    animation: _animationControllers[index],
                    builder: (_, child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, -17.5 * (_animationIconCircles[index] != null ? _animationIconCircles[index].value : -1.5), 0.0),
                        child: child,
                      );
                    },
                    child: Icon(
                      widget.items[index].icon,
                      color: whiteColor,
                    ),
                  );
                }).toList(),
              ),
              ClipPath(
                clipper: BottomBarClipper(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widget.items.map((item) {
                      var index = widget.items.indexOf(item);

                      return GestureDetector(
                        onTap: () {
                          if (!_animationControllers[index].isAnimating) {
                            context.read<BottomNavigationBloc>()..add(ChangeCurrentNav(index));
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _animationControllers[index],
                          builder: (_, child) {
                            return Transform(
                              transform: Matrix4.translationValues(0.0, -30.0 * (_animations[index] != null ? _animations[index].value : 0.0), 0.0),
                              child: child,
                            );
                          },
                          child: Icon(item.icon),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getBottomClipper(BuildContext context, int index) {
    final Size size = MediaQuery.of(context).size;
    switch (index) {
      case 0:
        return size.width / 4 - 40;
        break;
      case 1:
        return size.width / 2 - 35;
        break;
      case 2:
        return size.width * 3 / 4 - 30;
        break;
    }
  }

  _animateClipper(BuildContext context, int index) {
    widget.onTap(index);
    _animations[index] = Tween<double>(begin: 0.0, end: 1.0).animate(_animationControllers[index]);
    _animationIconCircles[index] = Tween<double>(begin: -1.5, end: 1.0).animate(_animationControllers[index]);
    _animationClipper =
        Tween<double>(begin: _getBottomClipper(context, _previousIndex), end: _getBottomClipper(context, index)).animate(_controllerClipper);
    _animationControllers[index].forward();
    _animationControllers[_previousIndex].reverse();
    _controllerClipper.addListener(() {
      if (_controllerClipper.isCompleted) {
        _animationClipper = Tween<double>(
          begin: _getBottomClipper(context, widget.index),
          end: _getBottomClipper(context, widget.index),
        ).animate(_controllerClipper);
        _controllerClipper.reset();
      }
      setState(() {});
    });
    _controllerClipper.forward();
    _previousIndex = index;
  }
}

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.arcTo(Rect.fromLTWH(_animationClipper != null ? _animationClipper.value : size.width / 2 - 35, -30, 70, 60), pi, -pi, true);
    path.lineTo(size.width, -50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BottomBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = blackColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    Path path = Path();
    path.moveTo(0, 20);
    path.cubicTo(
      0,
      10,
      10,
      0,
      20,
      0,
    );
    path.lineTo(_animationClipper != null ? _animationClipper.value : size.width / 2 - 35, 0);
    path.arcTo(Rect.fromLTWH(_animationClipper != null ? _animationClipper.value : size.width / 2 - 35, -30, 70, 60), pi, -pi, true);
    path.lineTo(size.width - 20, 0);
    path.cubicTo(
      size.width - 10,
      0,
      size.width,
      10,
      size.width,
      20,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
