import '../../../../di/service_locator.dart';
import '0_all_profile_view.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late AddressBloc _addressBloc;

  @override
  void initState() {
    super.initState();
    _addressBloc = getIt<AddressBloc>()..add(LoadAddressesEvent());
  }

  @override
  void dispose() {
    _addressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider.value(
      value: _addressBloc,
      child: BlocConsumer<AddressBloc, AddressState>(
        listenWhen: (previous, current) => previous.status != current.status,
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.addresses != current.addresses ||
            previous.isLoading != current.isLoading,
        listener: (context, state) {
          // Success messages
          if (state.status == AddressStatus.deleteSuccess) {
            ToastUtils.showSuccess(
              context,
              message: state.successMessage ?? 'Address deleted',
            );
          }
          if (state.status == AddressStatus.setDefaultSuccess) {
            ToastUtils.showSuccess(
              context,
              message: state.successMessage ?? 'Default address updated',
            );
          }
          if (state.status == AddressStatus.addSuccess ||
              state.status == AddressStatus.updateSuccess) {
            ToastUtils.showSuccess(
              context,
              message: state.successMessage ?? 'Address saved',
            );
          }

          // Error messages
          if (state.status == AddressStatus.error &&
              state.errorMessage != null) {
            ToastUtils.showError(context, message: state.errorMessage!);
          }
        },
        builder: (context, state) {
          final hasError =
              state.status == AddressStatus.error && state.addresses.isEmpty;

          return ScreenWrapper(
            useMobileScaffold: true,
            mobileHeader: CustomHeader(title: 'My Addresses'),
            isLoading: state.isLoading,
            hasError: hasError,
            isNetworkError: isNetworkError(state.errorMessage),
            errorMessage: state.errorMessage ?? 'Unable to load addresses',
            onRetry: () => _addressBloc.add(LoadAddressesEvent()),
            isEmpty: !state.isLoading && !hasError && !state.hasAddresses,
            emptyTitle: 'No Addresses Yet',
            emptyMessage: 'Add your first delivery address\nto start ordering',
            emptyLottie: 'assets/lottie/Location Lottie Animation.json',
            emptyIcon: Icons.location_on_outlined,
            mobile: _buildAddressList(context, state, colors),
          );
        },
      ),
    );
  }

  Widget _buildAddressList(
    BuildContext context,
    AddressState state,
    ThemeColors colors,
  ) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: AppSizes.paddingMd,
            vertical: AppSizes.paddingMd,
          ),
          child: AppRefreshIndicator(
            pageIcon: AppIcons.refreshAddresses,
            onRefresh: () async {
              _addressBloc.add(LoadAddressesEvent());
            },
            child: ListView.separated(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.addresses.length,
              separatorBuilder: (_, _) => SizedBox(height: 16.spMin),
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                return buildAddressCard(context, address, colors);
              },
            ),
          ),
        ),
        Positioned(
          right: 16.spMin,
          bottom: 16.spMin,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.addNewAddress,
              ).then((_) => _addressBloc.add(LoadAddressesEvent()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.spMin,
                vertical: 12.spMin,
              ),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: colors.textOnPrimary, size: 20.spMin),
                  SizedBox(width: 8.spMin),
                  Text(
                    'Add Address',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
