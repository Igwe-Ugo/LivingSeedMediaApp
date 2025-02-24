import 'package:flutter/material.dart';

class TooltipArrowPainter extends CustomPainter {
  final Size size;
  final Color color;
  final bool isInverted;

  TooltipArrowPainter(
      {super.repaint,
      required this.size,
      required this.color,
      required this.isInverted});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    if (isInverted) {
      path.moveTo(0.0, size.height);
      path.lineTo(size.width / 2, 0.0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0.0, 0.0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0.0);
    }
    path.close();
    canvas.drawShadow(path, color, 4.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TooltipArrow extends StatelessWidget {
  final Size size;
  final Color color;
  final bool isInverted;
  const TooltipArrow(
      {super.key,
      this.size = const Size(16, 16),
      this.color = Colors.white,
      this.isInverted = false});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-size.width / 2, 0.0),
      child: CustomPaint(
        size: size,
        painter: TooltipArrowPainter(
            size: size, color: color, isInverted: isInverted),
      ),
    );
  }
}

class AnimatedToolTip extends StatefulWidget {
  final Widget content;
  final GlobalKey? targetGlobalKey;
  final ThemeData? theme;
  final Widget? child;
  const AnimatedToolTip(
      {super.key,
      required this.content,
      this.targetGlobalKey,
      this.theme,
      this.child})
      : assert(child != null || targetGlobalKey != null);

  @override
  State<AnimatedToolTip> createState() => _AnimatedToolTipState();
}

class _AnimatedToolTipState extends State<AnimatedToolTip>
    with SingleTickerProviderStateMixin {
  late double? _toolTipTop;
  late double? _toolTipBottom;
  late Alignment _toolTipAlignment;
  late Alignment _transitionAlignment;
  late Alignment _arrowAlignment;
  bool _isInverted = false;
  final _arrowSize = const Size(16, 16);
  final _toolTipMinimumHeight = 140;

  final _overlayController = OverlayPortalController();
  late final AnimationController _animationController =
      AnimationController(duration: Duration(), vsync: this);
  late final Animation<double> _scaleAnimation =
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack);

  void _toggle() {
    _animationController.stop();
    if (_overlayController.isShowing) {
      _animationController.reverse().then((_) => _overlayController.hide());
    } else {
      _updatePosition();
      _overlayController.show();
      _animationController.forward();
    }
  }

  void _updatePosition() {
    final Size contextSize = MediaQuery.of(context).size;
    final BuildContext? targetContext = widget.targetGlobalKey != null
        ? widget.targetGlobalKey!.currentContext
        : context;
    final targetRenderBox = targetContext?.findRenderObject() as RenderBox;
    final targetOffset = targetRenderBox.localToGlobal(Offset.zero);
    final targetSize = targetRenderBox.size;

    // try to position the tooltip above target, else position it below or in the center of the target.
    final toolTipFitsAboveTarget = targetOffset.dy - _toolTipMinimumHeight >= 0;
    final toolTipFitsBelowTarget =
        targetOffset.dy + targetSize.height + _toolTipMinimumHeight <=
            contextSize.height;
    _toolTipTop = toolTipFitsAboveTarget
        ? null
        : toolTipFitsBelowTarget
            ? targetOffset.dy + targetSize.height
            : null;
    _toolTipBottom = toolTipFitsAboveTarget
        ? contextSize.height - targetOffset.dy
        : toolTipFitsBelowTarget
            ? null
            : targetOffset.dy + targetSize.height / 2;

    // if the tooltip is below the target, invert the arrow.
    _isInverted = _toolTipTop != null;
    // align the tooltip horizontally relative to the target
    _toolTipAlignment = Alignment(
        (targetOffset.dx) / (contextSize.width - targetSize.width) * 2 - 1.0,
        _isInverted ? 1.0 : -1.0);
    // make the tooltip appear from the target.
    _transitionAlignment = Alignment(
        (targetOffset.dx + targetSize.width / 2) / contextSize.width * 2 - 1.0,
        _isInverted ? -1.0 : 1.0);
    _arrowAlignment = Alignment(
        (targetOffset.dx + targetSize.width / 2) /
                (contextSize.width - _arrowSize.width) *
                2 -
            1.0,
        _isInverted ? 1.0 : -1.0);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _toggle();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if no theme provided, use opposite brightness of the current theme to make the tooltip stand out.
    final theme = widget.theme ??
        ThemeData(
            useMaterial3: true,
            brightness: Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light);
    return OverlayPortal.targetsRootOverlay(
      controller: _overlayController,
      child: widget.child != null
          ? GestureDetector(
              onTap: _toggle,
              child: widget.child,
            )
          : null,
      overlayChildBuilder: (context) {
        return Positioned(
          top: _toolTipTop,
          bottom: _toolTipBottom,

          // provided a transition alignment to make the tooltip appear from the target.
          child: ScaleTransition(
            alignment: _transitionAlignment,
            scale: _scaleAnimation,
            // TapRegion allows the tooltip to be dismissed by tapping outside of it
            child: TapRegion(
              onTapOutside: (PointerDownEvent event) {
                _toggle();
              },
              // if no theme is provided, a theme with inverted brightness is used.
              child: Theme(
                data: theme,
                // don't allow the tooltip to get wider than the screen.
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isInverted)
                        Align(
                          alignment: _arrowAlignment,
                          child: TooltipArrow(
                            size: _arrowSize,
                            isInverted: true,
                            color: theme.canvasColor,
                          ),
                        ),
                      Align(
                        alignment: _toolTipAlignment,
                        child: IntrinsicWidth(
                          child: Material(
                            elevation: 4.0,
                            color: theme.canvasColor,
                            borderRadius: BorderRadius.circular(8.0),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  widget.content,
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                        onPressed: _toggle,
                                        child: const Text('Ok')),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!_isInverted)
                        Align(
                          alignment: _arrowAlignment,
                          child: TooltipArrow(
                            size: _arrowSize,
                            isInverted: false,
                            color: theme.canvasColor,
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
