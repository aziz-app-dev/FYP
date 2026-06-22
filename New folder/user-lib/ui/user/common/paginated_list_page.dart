import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/shared/paginated/paginated_bloc.dart';
import '../../../bloc/shared/paginated/paginated_event.dart';
import '../../../bloc/shared/paginated/paginated_state.dart';
import '../../../config/config.dart';
import '../../../config/widgets/app_bar.dart';
import '../../../config/widgets/error_widget.dart';
import '../../../config/widgets/screen_wapper.dart';
import '../../../repo/shared/paginated/paginated_repo.dart';
import '../../../utils/loaders_utils.dart';

class PaginatedListPage<T> extends StatefulWidget {
  final String title;
  final PaginatedRepo<T> repo;
  final Widget Function(T item, ThemeColors colors) itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;

  const PaginatedListPage({
    super.key,
    required this.title,
    required this.repo,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
  });

  @override
  State<PaginatedListPage<T>> createState() => _PaginatedListPageState<T>();
}

class _PaginatedListPageState<T> extends State<PaginatedListPage<T>> {
  late PaginatedBloc<T> _bloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = PaginatedBloc<T>(repo: widget.repo, pageSize: 20);
    _bloc.add(FetchItems());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _bloc.add(LoadMoreItems());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<PaginatedBloc<T>, PaginatedState<T>>(
        builder: (context, state) {
          final itemsResponse = state.items;
          final isLoading = itemsResponse.isLoading;
          final hasError = itemsResponse.isError;
          final items = itemsResponse.data ?? [];
          final isEmpty = !isLoading && !hasError && items.isEmpty;

          return ScreenWrapper(
            mobileHeader: CustomHeader(title: widget.title),
            isLoading: isLoading,
            hasError: hasError,
            isNetworkError: isNetworkError(itemsResponse.message),
            errorTitle: 'Failed to load ${widget.title.toLowerCase()}',
            errorMessage: itemsResponse.message ?? 'Something went wrong',
            onRetry: () => _bloc.add(FetchItems()),
            isEmpty: isEmpty,
            emptyTitle: 'No ${widget.title}',
            emptyMessage: 'No ${widget.title.toLowerCase()} available at the moment',
            emptyIcon: Icons.inbox_outlined,
            mobile: _buildItemsGrid(context, state, items, colors),
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid(
    BuildContext context,
    PaginatedState<T> state,
    List<T> items,
    ThemeColors colors,
  ) {
    return AppRefreshIndicator(
      pageIcon: AppIcons.refreshPaginated,
      onRefresh: () async {
        _bloc.add(FetchItems(refresh: true));
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.spMin),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: 12.spMin,
                mainAxisSpacing: 12.spMin,
                childAspectRatio: widget.childAspectRatio,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => widget.itemBuilder(items[index], colors),
                childCount: items.length,
              ),
            ),
          ),
          if (state.isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.spMin),
                child: Center(child: appLoader(size: 30)),
              ),
            ),
          if (!state.hasMore && items.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.spMin),
                child: Center(
                  child: Text(
                    'No more items',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textHint,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
