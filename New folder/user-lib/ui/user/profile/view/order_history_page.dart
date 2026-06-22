import '../../../../di/service_locator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../ui/user/profile/view/0_all_profile_view.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late OrderBloc _orderBloc;
  final ScrollController _scrollController = ScrollController();
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _orderBloc = getIt<OrderBloc>()..add(const LoadOrderHistoryEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _orderBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _orderBloc.add(const LoadMoreOrderHistoryEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = _sessionManager.currencySymbol;

    return BlocProvider.value(
      value: _orderBloc,
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          final isLoading =
              state.status == OrderLoadingStatus.loading &&
              state.orderHistory.isEmpty;
          final hasError =
              state.status == OrderLoadingStatus.failure &&
              state.orderHistory.isEmpty;
          final isEmpty = !isLoading && !hasError && state.orderHistory.isEmpty;

          return ScreenWrapper(
            mobileHeader: CustomHeader(title: 'Order History'),
            isLoading: isLoading,
            hasError: hasError,
            isNetworkError: isNetworkError(state.errorMessage),
            errorTitle: 'Failed to load orders',
            errorMessage: state.errorMessage ?? 'Something went wrong',
            onRetry: () =>
                _orderBloc.add(const LoadOrderHistoryEvent(refresh: true)),
            isEmpty: isEmpty,
            emptyTitle: 'No Order History',
            emptyMessage:
                'Your completed and cancelled orders\nwill appear here',
            emptyLottie: 'assets/lottie/Order History.json',
            emptyIcon: Icons.receipt_long_outlined,
            mobile: _buildOrderList(state, currencySymbol),
            tablet: _buildTabletDesktopList(state, currencySymbol, 600.spMin),
            desktop: _buildTabletDesktopList(state, currencySymbol, 800.spMin),
          );
        },
      ),
    );
  }

  Widget _buildOrderList(OrderState state, String currencySymbol) {
    return AppRefreshIndicator(
      pageIcon: AppIcons.refreshOrderHistory,
      onRefresh: () async {
        _orderBloc.add(const LoadOrderHistoryEvent(refresh: true));
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: AnimationLimiter(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
          itemCount:
              state.orderHistory.length + (state.canLoadMoreHistory ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.orderHistory.length) {
              return _buildLoadingIndicator();
            }

            final order = state.orderHistory[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: OrderHistoryCard(
                    order: order,
                    currencySymbol: currencySymbol,
                    style: OrderCardStyle.bordered,
                    onTap: () => _showOrderDetails(order),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabletDesktopList(
    OrderState state,
    String currencySymbol,
    double maxWidth,
  ) {
    return Center(
      child: SizedBox(
        width: maxWidth,
        child: AnimationLimiter(
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
            itemCount:
                state.orderHistory.length + (state.canLoadMoreHistory ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.orderHistory.length) {
                return _buildLoadingIndicator();
              }

              final order = state.orderHistory[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: OrderHistoryCard(
                      order: order,
                      currencySymbol: currencySymbol,
                      style: OrderCardStyle.bordered,
                      onTap: () => _showOrderDetails(order),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(child: appLoader()),
    );
  }

  void _showOrderDetails(OrderModel order) {
    final colors = context.colors;
    final currencySymbol = _sessionManager.currencySymbol;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => OrderDetailsSheet(
          order: order,
          currencySymbol: currencySymbol,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
