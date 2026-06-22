import '../../../../config/widgets/rating_card.dart';

import '../widgets/tab_widget.dart';
import '../../../../di/service_locator.dart';
import '0_all_profile_view.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage>
    with SingleTickerProviderStateMixin {
  late RatingBloc _ratingBloc;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _ratingBloc = getIt<RatingBloc>()..add(const LoadUserRatingsEvent());
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _ratingBloc.close();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _ratingBloc.add(ChangeTabEvent(_tabController.index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider.value(
      value: _ratingBloc,
      child: BlocConsumer<RatingBloc, RatingState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == RatingStatus.deleteSuccess) {
            ToastUtils.showSuccess(
              context,
              message: state.successMessage ?? 'Review deleted',
            );
          }
          if (state.status == RatingStatus.updateSuccess) {
            ToastUtils.showSuccess(
              context,
              message: state.successMessage ?? 'Review updated',
            );
          }
          if (state.status == RatingStatus.error &&
              state.errorMessage != null) {
            ToastUtils.showError(context, message: state.errorMessage!);
          }
        },
        builder: (context, state) {
          return ScreenWrapper(
            useMobileScaffold: true,
            mobileHeader: CustomHeader(title: 'My Reviews'),
            mobile: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSm),
              child: Column(
                children: [
                  // Stats Card
                  // buildStatsCard(context, colors),

                  // SizedBox(height: 16.spMin),

                  // Tabs
                  buildTabBar(colors, _tabController),

                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildReviewsList(
                          context,
                          state.foodRatings,
                          colors,
                          state,
                        ),
                        _buildReviewsList(
                          context,
                          state.restaurantRatings,
                          colors,
                          state,
                        ),
                        _buildReviewsList(
                          context,
                          state.driverRatings,
                          colors,
                          state,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsList(
    BuildContext context,
    List<RatingModel> ratings,
    ThemeColors colors,
    RatingState state,
  ) {
    if (state.isLoading) {
      return Center(child: appLoader());
    }

    if (state.status == RatingStatus.error && ratings.isEmpty) {
      return Center(
        child: isNetworkError(state.errorMessage)
            ? AppErrorWidget.noInternet(
                onRetry: () => _ratingBloc.add(const LoadUserRatingsEvent()),
              )
            : AppErrorWidget.general(
                title: 'Something went wrong',
                message: state.errorMessage ?? 'Unable to load reviews',
                onRetry: () => _ratingBloc.add(const LoadUserRatingsEvent()),
              ),
      );
    }

    if (ratings.isEmpty) {
      return reviewEmptyState(colors);
    }

    return AppRefreshIndicator(
      pageIcon: AppIcons.refreshReviews,
      onRefresh: () async {
        _ratingBloc.add(const LoadUserRatingsEvent());
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.spMin),
        itemCount: ratings.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.spMin),
        itemBuilder: (context, index) {
          final rating = ratings[index];
          return RatingCard(rating: rating, colors: colors, state: state);
        },
      ),
    );
  }
}
