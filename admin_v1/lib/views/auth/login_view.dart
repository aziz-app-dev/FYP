import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/res/colors/app_color.dart';
import '../../common/res/components/coustom_textformfield.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/res/components/round_button.dart';
import '../../common/utils/utils.dart';
import '../../view models/controllers/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscure = true;

  final LoginController _controller = Get.put(LoginController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    _controller.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kPrimary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: kPrimary,
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const ReuseableText(
                      text: 'Super Admin',
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      textColor: kDark,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    const ReuseableText(
                      text: 'Sign in to manage orders, restaurants and users',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      textColor: kGray,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    CoustomTextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      hintText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                      onFieldSubmitted: (_) => Utils.fieldFocusChange(
                          context, _emailFocus, _passwordFocus),
                    ),
                    const SizedBox(height: 16),
                    CoustomTextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: kGray,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        if (v.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 28),
                    Obx(
                      () => RoundButton(
                        title: 'Sign In',
                        loading: _controller.isLoading,
                        onPress: _submit,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const ReuseableText(
                      text: 'Admin access only',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: kGrayLight,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
