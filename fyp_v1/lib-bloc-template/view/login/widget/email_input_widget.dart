import 'package:bloc_template/utils/extensions/validations_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_template/l10n/generated/app_localizations.dart';

import '../../../bloc/login_bloc/login_bloc.dart';

/// A widget representing the email input field.
class EmailInputWidget extends StatefulWidget {
  const EmailInputWidget({super.key});

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LoginBloc, LoginStates>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return TextFormField(
          controller: _emailController,
          focusNode: _focusNode,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            labelText: l10n.email,
            helperText: l10n.aCompleteValidEmailExamplejoegmailcom,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.email;
            }
            if (!value.emailValidator()) {
              return l10n.aCompleteValidEmailExamplejoegmailcom;
            }
            return null;
          },
          onChanged: (value) {
            context.read<LoginBloc>().add(EmailChanged(email: value));
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}
