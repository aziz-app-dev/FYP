import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_template/l10n/generated/app_localizations.dart';

import '../../../bloc/login_bloc/login_bloc.dart';
import '../../../configs/constants/app_constants.dart';

/// A widget representing the password input field.
class PasswordInputWidget extends StatefulWidget {
  const PasswordInputWidget({super.key});

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _focusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LoginBloc, LoginStates>(
      buildWhen: (current, previous) => false,
      builder: (context, state) {
        return TextFormField(
          controller: _passwordController,
          focusNode: _focusNode,
          obscureText: _obscureText,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            labelText: l10n.password,
            helperText: l10n
                .passwordShouldbeatleast_characterswithatleastoneletterandnumber,
            helperMaxLines: 2,
            errorMaxLines: 2,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.password;
            }
            if (value.length < AppConstants.minPasswordLength) {
              return l10n
                  .passwordShouldbeatleast_characterswithatleastoneletterandnumber;
            }
            return null;
          },
          onChanged: (value) {
            context.read<LoginBloc>().add(PasswordChanged(password: value));
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}
