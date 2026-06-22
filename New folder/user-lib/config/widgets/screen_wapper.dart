import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../bloc/user/main/main_bloc.dart';
import '../../bloc/user/main/main_event.dart';
import '../../bloc/user/main/main_state.dart';
import '../../utils/loaders_utils.dart';
import '../config.dart';

class ScreenWrapper extends StatefulWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  final Widget? mobileHeader;
  final Widget? tabletHeader;
  final Widget? desktopHeader;

  final Widget? headerBackground;

  final Duration animationDuration;
  final bool enableScrollHideHeader;
  final bool useMobileScaffold;
  final bool? topSafeArea;

  /// Height of the header for tablet/desktop layouts.
  /// This determines the spacing between the header and body content.
  /// Set to null to use default (120.spMin), or provide custom height.
  final double? headerHeight;

  /// Whether the body should have rounded top corners (mobile only).
  /// Defaults to false.
  final bool isTopRounded;

  /// Whether to show header with background color and shadow.
  /// Set to false for pages like home where the header blends with the body.
  /// Defaults to true.
  final bool showHeaderDecoration;

  // Loading state
  final bool isLoading;

  // Error state
  final bool hasError;
  final String? errorTitle;
  final String? errorMessage;
  final bool isNetworkError;
  final VoidCallback? onRetry;
  final String? errorLottie;
  final IconData? errorIcon;

  // Empty state
  final bool isEmpty;
  final String? emptyTitle;
  final String? emptyMessage;
  final String? emptyLottie;
  final IconData? emptyIcon;

  const ScreenWrapper({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobileHeader,
    this.tabletHeader,
    this.desktopHeader,
    this.headerBackground,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enableScrollHideHeader = true,
    this.useMobileScaffold = false,
    this.headerHeight,
    this.isTopRounded = false,
    this.showHeaderDecoration = true,
    // Loading
    this.isLoading = false,
    // Error
    this.hasError = false,
    this.errorTitle,
    this.errorMessage,
    this.isNetworkError = false,
    this.onRetry,
    this.errorLottie,
    this.errorIcon,
    // Empty
    this.isEmpty = false,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyLottie,
    this.emptyIcon,
    this.topSafeArea,
  });

  @override
  State<ScreenWrapper> createState() => _ScreenWrapperState();
}

enum _ScreenMode { mobile, tablet, desktop }

class _ScreenWrapperState extends State<ScreenWrapper> {
  final ScrollController _scrollController = ScrollController();
  MainBloc? _mainBloc;

  // Cache to avoid rebuilds on every resize pixel
  _ScreenMode? _lastMode;
  Widget? _cachedBuild;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Try to get MainBloc if available
    try {
      _mainBloc = context.read<MainBloc>();
    } catch (_) {
      _mainBloc = null;
    }
  }

  @override
  void didUpdateWidget(ScreenWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Invalidate cache when widget properties change
    if (widget.mobile != oldWidget.mobile ||
        widget.tablet != oldWidget.tablet ||
        widget.desktop != oldWidget.desktop ||
        widget.mobileHeader != oldWidget.mobileHeader ||
        widget.tabletHeader != oldWidget.tabletHeader ||
        widget.desktopHeader != oldWidget.desktopHeader ||
        widget.isLoading != oldWidget.isLoading ||
        widget.hasError != oldWidget.hasError ||
        widget.isEmpty != oldWidget.isEmpty ||
        widget.useMobileScaffold != oldWidget.useMobileScaffold ||
        widget.headerHeight != oldWidget.headerHeight ||
        widget.isTopRounded != oldWidget.isTopRounded ||
        widget.showHeaderDecoration != oldWidget.showHeaderDecoration) {
      _cachedBuild = null;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (!widget.enableScrollHideHeader) return;
    if (_mainBloc == null) return;

    _mainBloc!.add(
      ScrollEvent(
        currentOffset: _scrollController.offset,
        enableScrollHideHeader: widget.enableScrollHideHeader,
      ),
    );
  }

  static _ScreenMode _computeMode(double width) {
    if (width >= 1024) return _ScreenMode.desktop;
    if (width >= 600) return _ScreenMode.tablet;
    return _ScreenMode.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mode = _computeMode(width);

    // Return cached layout if breakpoint hasn't changed
    if (mode == _lastMode && _cachedBuild != null) {
      return _cachedBuild!;
    }

    _lastMode = mode;

    final colors = context.colors;
    final isDesktop = mode == _ScreenMode.desktop;
    final isTablet = mode == _ScreenMode.tablet;

    // Select appropriate content
    final selectedBody = isDesktop
        ? (widget.desktop ?? widget.tablet ?? widget.mobile)
        : isTablet
        ? (widget.tablet ?? widget.mobile)
        : widget.mobile;

    final selectedHeader = isDesktop
        ? (widget.desktopHeader ?? widget.tabletHeader ?? widget.mobileHeader)
        : isTablet
        ? (widget.tabletHeader ?? widget.mobileHeader)
        : widget.mobileHeader;

    // Get appropriate body based on loading/error/empty states
    final bodyContent = _getBodyContent(selectedBody, colors);

    // Default header height or custom
    final effectiveHeaderHeight = widget.headerHeight ?? 120.spMin;

    // ── Tablet & Desktop: Overlay header with hide on scroll ─────
    if ((isTablet || isDesktop) && !widget.useMobileScaffold) {
      // If MainBloc is not available, show header always
      if (_mainBloc == null) {
        _cachedBuild = Scaffold(
          backgroundColor: colors.scaffoldBackground,
          body: Stack(
            children: [
              ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 0),
                children: [
                  // space between header and body
                  SizedBox(height: effectiveHeaderHeight),
                  bodyContent,
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildHeader(context, selectedHeader, isDesktop),
              ),
            ],
          ),
        );
        return _cachedBuild!;
      }

      _cachedBuild = BlocBuilder<MainBloc, MainState>(
        bloc: _mainBloc,
        buildWhen: (previous, current) =>
            previous.showHeader != current.showHeader,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: colors.scaffoldBackground,
            body: Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 0),
                  children: [
                    isTablet || isDesktop
                        ? SizedBox(height: effectiveHeaderHeight)
                        : const SizedBox.shrink(),
                    bodyContent,
                  ],
                ),
                AnimatedPositioned(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  top: state.showHeader ? 0 : -(effectiveHeaderHeight + 220),
                  left: 0,
                  right: 0,
                  child: _buildHeader(context, selectedHeader, isDesktop),
                ),
              ],
            ),
          );
        },
      );
      return _cachedBuild!;
    }

    // ── Mobile: Classic header + rounded body ────────
    final statusBarStyle = context.isDarkMode
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: colors.scaffoldBackground,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: colors.scaffoldBackground,
          );

    _cachedBuild = AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarStyle,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            widget.headerBackground ??
                Container(
                  width: double.infinity,
                  height: 400.spMin,
                  color: colors.scaffoldBackground,
                ),
            Column(
              children: [
                if (selectedHeader != null)
                  widget.showHeaderDecoration
                      ? Container(
                          decoration: BoxDecoration(
                            color: colors.headerBackground,
                            boxShadow: [
                              BoxShadow(
                                color: colors.shadow.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            top: widget.topSafeArea ?? true,
                            bottom: false,
                            child: selectedHeader,
                          ),
                        )
                      : SafeArea(
                          top: widget.topSafeArea ?? true,
                          bottom: false,
                          child: selectedHeader,
                        )
                else
                  SafeArea(
                    top: widget.topSafeArea ?? true,
                    bottom: false,
                    child: SizedBox(height: 80.h),
                  ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: widget.isTopRounded
                        ? BorderRadius.vertical(top: Radius.circular(28.r))
                        : BorderRadius.zero,
                    child: Container(
                      color: colors.scaffoldBackground,
                      child: bodyContent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return _cachedBuild!;
  }

  Widget _buildHeader(
    BuildContext context,
    Widget? headerContent,
    bool isDesktop,
  ) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(0.spMin),
        child: Container(
          decoration: BoxDecoration(
            color: colors.scaffoldBackground,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Stack(
            children: [
              if (widget.headerBackground != null) widget.headerBackground!,
              headerContent ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  /// Wraps content in a centered container that handles unbounded height
  /// Uses a slight upward bias (-0.3) so empty states don't feel too low
  /// Adds bottom padding when inside MainScreen to avoid floating nav bar overlap
  Widget _buildCenteredContent(Widget content) {
    const alignment = Alignment(0.0, -0.3);
    // Add bottom padding when inside MainScreen (has floating nav bar)
    final navBarPadding = _mainBloc != null ? 100.spMin : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // If height is unbounded (inside ListView), use viewport height
        if (constraints.maxHeight == double.infinity) {
          final screenHeight = MediaQuery.sizeOf(context).height;
          final topPadding = MediaQuery.of(context).padding.top;
          final bottomPadding = MediaQuery.of(context).padding.bottom;
          final headerHeight = widget.headerHeight ?? 120.spMin;
          final viewportHeight =
              screenHeight - topPadding - bottomPadding - headerHeight;

          return SizedBox(
            height: viewportHeight,
            child: Padding(
              padding: EdgeInsets.only(bottom: navBarPadding),
              child: Align(alignment: alignment, child: content),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(bottom: navBarPadding),
          child: Align(alignment: alignment, child: content),
        );
      },
    );
  }

  /// Builds the loading state widget
  Widget _buildLoadingState(ThemeColors colors) {
    return _buildCenteredContent(appLoader());
  }

  /// Builds the error state widget
  Widget _buildErrorState(ThemeColors colors) {
    // Default Lottie paths for error states
    const networkErrorLottie = 'assets/lottie/No Internet Connection.json';
    const generalErrorLottie =
        'assets/lottie/Sign for error or explanation alert.json';

    // Determine which Lottie to use
    final errorLottiePath =
        widget.errorLottie ??
        (widget.isNetworkError ? networkErrorLottie : generalErrorLottie);

    final content = Padding(
      padding: AppSizes.paddingAllLg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            errorLottiePath,
            width: 150.spMin,
            height: 150.spMin,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorIcon(colors),
          ),
          SizedBox(height: 16.spMin),
          Text(
            widget.errorTitle ??
                (widget.isNetworkError
                    ? 'No Internet Connection'
                    : 'Something went wrong'),
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.spMin),
          Text(
            widget.errorMessage ??
                (widget.isNetworkError
                    ? 'Please check your connection and try again'
                    : 'An error occurred. Please try again.'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.onRetry != null) ...[
            SizedBox(height: 24.spMin),
            ElevatedButton.icon(
              onPressed: widget.onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.spMin,
                  vertical: 12.spMin,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return _buildCenteredContent(content);
  }

  Widget _buildErrorIcon(ThemeColors colors) {
    return Container(
      width: 120.spMin,
      height: 120.spMin,
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.errorIcon ??
            (widget.isNetworkError
                ? Icons.wifi_off_rounded
                : Icons.error_outline_rounded),
        size: 60.spMin,
        color: colors.error,
      ),
    );
  }

  /// Builds the empty state widget
  Widget _buildEmptyState(ThemeColors colors) {
    final content = Padding(
      padding: AppSizes.paddingAllLg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.emptyLottie != null)
            Lottie.asset(
              widget.emptyLottie!,
              width: 150.spMin,
              height: 150.spMin,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  _buildEmptyIcon(colors),
            )
          else
            _buildEmptyIcon(colors),
          SizedBox(height: 16.spMin),
          Text(
            widget.emptyTitle ?? 'Nothing Here',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.emptyMessage != null) ...[
            SizedBox(height: 8.spMin),
            Text(
              widget.emptyMessage!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    return _buildCenteredContent(content);
  }

  Widget _buildEmptyIcon(ThemeColors colors) {
    return Container(
      width: 150.spMin,
      height: 150.spMin,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.emptyIcon ?? Icons.inbox_outlined,
        size: 70.spMin,
        color: colors.primary,
      ),
    );
  }

  /// Gets the appropriate body content based on state
  Widget _getBodyContent(Widget selectedBody, ThemeColors colors) {
    if (widget.isLoading) {
      return _buildLoadingState(colors);
    }
    if (widget.hasError) {
      return _buildErrorState(colors);
    }
    if (widget.isEmpty) {
      return _buildEmptyState(colors);
    }
    return selectedBody;
  }
}
