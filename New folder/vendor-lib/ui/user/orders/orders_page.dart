import 'package:food/ui/user/profile/view/0_all_profile_view.dart';
import '../../../bloc/user/main/main_bloc.dart';
import '../../../bloc/user/main/main_state.dart';
import '../../../di/service_locator.dart';
import 'widgets/activer_order_list.dart';
import 'widgets/order_history_list.dart';

class OrdersPage extends StatefulWidget {
  final int tabIndex;

  const OrdersPage({super.key, this.tabIndex = 2});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late OrderBloc _orderBloc;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _orderBloc = getIt<OrderBloc>()..add(const RefreshOrdersEvent());
  }

  @override
  void dispose() {
    _orderBloc.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocListener<MainBloc, MainState>(
      listenWhen: (prev, curr) =>
          prev.selectedIndex != curr.selectedIndex &&
          curr.selectedIndex == widget.tabIndex,
      listener: (context, state) {
        _orderBloc.add(const RefreshOrdersEvent());
      },
      child: BlocProvider.value(
        value: _orderBloc,
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            final isLoading =
                state.status == OrderLoadingStatus.loading &&
                state.activeOrders.isEmpty &&
                state.orderHistory.isEmpty;

            final hasError =
                state.status == OrderLoadingStatus.failure &&
                state.activeOrders.isEmpty &&
                state.orderHistory.isEmpty;

            return ScreenWrapper(
              mobileHeader: const CustomHeader(
                title: 'My Orders',
                showBackButton: false,
              ),
              enableScrollHideHeader: false,
              isLoading: isLoading,
              hasError: hasError,
              isNetworkError: isNetworkError(state.errorMessage),
              errorTitle: 'Failed to load orders',
              errorMessage: state.errorMessage ?? 'Something went wrong',
              onRetry: () => _orderBloc.add(const RefreshOrdersEvent()),
              mobile: _buildTabs(colors, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabs(ThemeColors colors, OrderState state) {
    final pendingOrders = state.activeOrders;
    final deliveredOrders = state.orderHistory
        .where((o) => o.orderStatus.isCompleted)
        .toList();
    final cancelledOrders = state.orderHistory
        .where((o) => o.orderStatus.isCancelled)
        .toList();

    return Column(
      children: [
        // Tab bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: colors.textOnPrimary,
            unselectedLabelColor: colors.textSecondary,
            labelStyle: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
            padding: EdgeInsets.all(4.w),
            tabs: [
              _buildTab('Pending', pendingOrders.length, colors),
              _buildTab('Delivered', deliveredOrders.length, colors),
              _buildTab('Cancelled', cancelledOrders.length, colors),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              pendingOrders.isEmpty
                  ? _buildEmptyTab(
                      colors,
                      Icons.pending_actions_rounded,
                      'No Pending Orders',
                      'Your active orders will appear here',
                    )
                  : buildActiveOrdersList(colors, state, context),
              deliveredOrders.isEmpty
                  ? _buildEmptyTab(
                      colors,
                      Icons.check_circle_outline_rounded,
                      'No Delivered Orders',
                      'Your delivered orders will appear here',
                    )
                  : _buildFilteredHistoryList(colors, deliveredOrders, context),
              cancelledOrders.isEmpty
                  ? _buildEmptyTab(
                      colors,
                      Icons.cancel_outlined,
                      'No Cancelled Orders',
                      'Your cancelled orders will appear here',
                    )
                  : _buildFilteredHistoryList(colors, cancelledOrders, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int count, ThemeColors colors) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          if (count > 0) ...[
            SizedBox(width: 4.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: colors.textOnPrimary.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                '$count',
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyTab(
    ThemeColors colors,
    IconData icon,
    String title,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50.spMin, color: colors.primary),
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredHistoryList(
    ThemeColors colors,
    List<OrderModel> orders,
    BuildContext context,
  ) {
    final sessionManager = SessionManager();

    return AppRefreshIndicator(
      pageIcon: AppIcons.refreshOrderHistory,
      onRefresh: () async {
        context.read<OrderBloc>().add(const RefreshOrdersEvent());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 100.h),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return HistoryOrderCard(
            order: order,
            currencySymbol: sessionManager.currencySymbol,
            style: OrderCardStyle.bordered,
            onTap: () => showOrderDetails(order, context),
          );
        },
      ),
    );
  }
}
