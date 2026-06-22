import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/vendor/vendor_menu/vendor_menu_bloc.dart';
import '../../../bloc/vendor/vendor_menu/vendor_menu_event.dart';
import '../../../bloc/vendor/vendor_menu/vendor_menu_state.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../config/widgets/price_widget.dart';
import '../../../di/service_locator.dart';
import '../../../model/home/home_model.dart';
import '../../../routes/route_name.dart';
import '../../../utils/toast_utils.dart';

class VendorMenuPage extends StatelessWidget {
  const VendorMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VendorMenuBloc>(),
      child: const _MenuView(),
    );
  }
}

class _MenuView extends StatefulWidget {
  const _MenuView();

  @override
  State<_MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<_MenuView> {
  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  void _loadMenu() {
    final restState = context.read<VendorRestaurantBloc>().state;
    final id = restState.activeRestaurant?.id;
    if (id != null) {
      context.read<VendorMenuBloc>().add(LoadMenuItems(restaurantId: id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Management')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, RouteName.createMenuItem);
          _loadMenu();
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<VendorMenuBloc, VendorMenuState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ToastUtils.showSuccess(context, message: state.successMessage!);
          }
          if (state.hasError) {
            ToastUtils.showError(context, message: state.errorMessage ?? 'Error');
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.menuItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.menuItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 64.spMin, color: Colors.grey),
                  SizedBox(height: 16.spMin),
                  const Text('No menu items yet'),
                  SizedBox(height: 8.spMin),
                  const Text('Tap + to add your first item'),
                ],
              ),
            );
          }

          final grouped = state.itemsByCategory;
          return ListView(
            padding: EdgeInsets.all(12.spMin),
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.spMin),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 16.spMin,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...entry.value.map((item) => _MenuItemTile(
                        item: item,
                        onRefresh: _loadMenu,
                      )),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onRefresh;

  const _MenuItemTile({required this.item, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.spMin),
      child: ListTile(
        leading: item.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl!,
                  width: 56.spMin,
                  height: 56.spMin,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 56.spMin,
                height: 56.spMin,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.fastfood),
              ),
        title: Text(item.title ?? 'Untitled'),
        subtitle: Text(
          item.price != null ? formatPrice(item.price!) : 'Price varies',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: item.isAvailable ?? true,
              onChanged: (_) {
                if (item.id != null) {
                  context.read<VendorMenuBloc>().add(
                        ToggleMenuItemAvailability(foodId: item.id!),
                      );
                }
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.pushNamed(
                    context,
                    RouteName.editMenuItem,
                    arguments: item,
                  ).then((_) => onRefresh());
                } else if (value == 'delete' && item.id != null) {
                  context.read<VendorMenuBloc>().add(
                        DeleteMenuItem(foodId: item.id!),
                      );
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
