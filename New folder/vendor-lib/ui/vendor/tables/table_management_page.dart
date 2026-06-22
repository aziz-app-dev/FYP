import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_bloc.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_event.dart';
import '../../../bloc/vendor/vendor_restaurant/vendor_restaurant_state.dart';
import '../../../utils/toast_utils.dart';

class TableManagementPage extends StatelessWidget {
  const TableManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Table Management')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTableDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<VendorRestaurantBloc, VendorRestaurantState>(
        builder: (context, state) {
          final restaurant = state.activeRestaurant;
          final tables = restaurant?.tables ?? [];

          if (tables.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.table_restaurant, size: 64.spMin, color: Colors.grey),
                  SizedBox(height: 16.spMin),
                  const Text('No tables configured'),
                  SizedBox(height: 8.spMin),
                  const Text('Tap + to add a table'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12.spMin),
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8.spMin),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${table.tableNumber ?? index + 1}'),
                  ),
                  title: Text('Table ${table.tableNumber ?? index + 1}'),
                  subtitle: Text(
                    'Capacity: ${table.capacity ?? 0} | Area: ${table.area ?? "Indoor"}',
                  ),
                  trailing: Icon(
                    Icons.circle,
                    size: 12.spMin,
                    color: table.isAvailable == true ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showTableDialog(BuildContext context) {
    final numberCtrl = TextEditingController();
    final capacityCtrl = TextEditingController();
    String area = 'Indoor';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Table'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberCtrl,
              decoration: const InputDecoration(labelText: 'Table Number'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8.spMin),
            TextField(
              controller: capacityCtrl,
              decoration: const InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8.spMin),
            DropdownButtonFormField<String>(
              initialValue: area,
              items: ['Indoor', 'Outdoor', 'Terrace', 'Rooftop']
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
              onChanged: (v) => area = v ?? 'Indoor',
              decoration: const InputDecoration(labelText: 'Area'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final restState = context.read<VendorRestaurantBloc>().state;
              final restaurant = restState.activeRestaurant;
              if (restaurant == null) return;

              final currentTables = restaurant.tables?.map((t) => t.toJson()).toList() ?? [];
              currentTables.add({
                'tableNumber': int.tryParse(numberCtrl.text) ?? currentTables.length + 1,
                'capacity': int.tryParse(capacityCtrl.text) ?? 4,
                'area': area,
                'isAvailable': true,
              });

              context.read<VendorRestaurantBloc>().add(UpdateRestaurant(
                    restaurantId: restaurant.id!,
                    data: {'tables': currentTables},
                  ));
              Navigator.pop(dialogContext);
              ToastUtils.showSuccess(context, message: 'Table added');
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
