import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config.dart';

/// A pull-to-refresh widget that shows a page-contextual icon
/// centred inside a circular progress ring.
class AppRefreshIndicator extends StatefulWidget {
  final IconData pageIcon;
  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? color;

  const AppRefreshIndicator({
    super.key,
    required this.pageIcon,
    required this.onRefresh,
    required this.child,
    this.color,
  });

  @override
  State<AppRefreshIndicator> createState() => _AppRefreshIndicatorState();
}

class _AppRefreshIndicatorState extends State<AppRefreshIndicator>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _dragOffset = ValueNotifier<double>(0.0);
  final ValueNotifier<bool> _isRefreshing = ValueNotifier<bool>(false);
  late final AnimationController _dismissCtrl;

  static const _triggerOffset = 80.0;
  static const _maxDrag = 130.0;

  @override
  void initState() {
    super.initState();
    _dismissCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener(_onDismissEnd);
  }

  @override
  void dispose() {
    _dismissCtrl.removeStatusListener(_onDismissEnd);
    _dismissCtrl.dispose();
    _dragOffset.dispose();
    _isRefreshing.dispose();
    super.dispose();
  }

  void _onDismissEnd(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _dismissCtrl.reset();
      _dragOffset.value = 0;
      _isRefreshing.value = false;
    }
  }

  // ── scroll tracking ──────────────────────────────────────

  bool _onScrollNotification(ScrollNotification n) {
    if (_isRefreshing.value || _dismissCtrl.isAnimating) return false;

    if (n is OverscrollNotification && n.overscroll < 0) {
      // Android clamping physics
      _dragOffset.value =
          (_dragOffset.value - n.overscroll).clamp(0.0, _maxDrag);
    } else if (n is ScrollUpdateNotification && n.metrics.pixels < 0) {
      // iOS bouncing physics
      _dragOffset.value = (-n.metrics.pixels).clamp(0.0, _maxDrag);
    }

    return false;
  }

  void _onPointerUp(PointerUpEvent _) {
    if (_dragOffset.value <= 0 ||
        _isRefreshing.value ||
        _dismissCtrl.isAnimating) {
      return;
    }

    if (_dragOffset.value >= _triggerOffset) {
      _startRefresh();
    } else {
      _dismiss();
    }
  }

  // ── refresh lifecycle ────────────────────────────────────

  Future<void> _startRefresh() async {
    _isRefreshing.value = true;
    _dragOffset.value = _triggerOffset;
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) _dismiss();
    }
  }

  void _dismiss() => _dismissCtrl.forward(from: 0);

  // ── build ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final indicatorColor = widget.color ?? colors.primary;

    return Listener(
      onPointerUp: _onPointerUp,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: Stack(
          children: [
            widget.child,
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation:
                    Listenable.merge([_dismissCtrl, _dragOffset, _isRefreshing]),
                builder: (context, _) {
                  if (_dragOffset.value <= 0) return const SizedBox.shrink();
                  final t = _dismissCtrl.isAnimating
                      ? (1.0 - _dismissCtrl.value)
                      : 1.0;
                  final offset = _dragOffset.value * t;
                    if (offset <= 0) return const SizedBox.shrink();

                    final progress =
                        (offset / _triggerOffset).clamp(0.0, 1.0);

                    return Center(
                      child: Opacity(
                        opacity: t,
                        child: Transform.scale(
                          scale: t.clamp(0.5, 1.0),
                          child: Container(
                            margin: EdgeInsets.only(
                              top: (offset * 0.6).clamp(0.0, 60.0).spMin,
                            ),
                            width: 48.spMin,
                            height: 48.spMin,
                            decoration: BoxDecoration(
                              color: colors.cardBackground,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: .1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 42.spMin,
                                  height: 42.spMin,
                                  child: CircularProgressIndicator(
                                    value: _isRefreshing.value
                                        ? null
                                        : progress,
                                    strokeWidth: 2.5,
                                    color: indicatorColor,
                                    backgroundColor: indicatorColor
                                        .withValues(alpha: .15),
                                  ),
                                ),
                                Icon(
                                  widget.pageIcon,
                                  size: 20.spMin,
                                  color: indicatorColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
