import 'package:flutter/material.dart';
import '../../../../models/address/address_respose_model.dart';
import '../../../../res/colors/app_color.dart';
import 'address_tile_widget.dart';

class AddressListWidget extends StatelessWidget {
  const AddressListWidget({super.key, required this.addresses});
  final List<AddressResponseModel>? addresses;

  @override
  Widget build(BuildContext context) {
    if (addresses == null || addresses!.isEmpty) {
      return const Center(child: Text('No addresses found.'));
    }
    return ListView.builder(
      itemCount: addresses!.length,
      itemBuilder: (context, index) {
        final address = addresses![index];
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: kGray, width: 0.5),
              top: BorderSide(color: kGray, width: 0.5),
            ),
          ),
          child: AddressTile(addresses: address),
        );
      },
    );
  }
}
