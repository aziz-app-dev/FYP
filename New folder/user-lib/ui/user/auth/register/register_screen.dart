import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../bloc/user/register/register_bloc.dart';
import '../../../../config/config.dart';
import '../../../../di/service_locator.dart';
import '../widgets/auth_header.dart';
import 'widgets/bottom_link_widget.dart';
import 'widgets/check_box_widget.dart';
import 'widgets/email_widget.dart';
import 'widgets/password_widget.dart';
import 'widgets/register_btn.dart';
import 'widgets/user_name_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameNode = FocusNode();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _confirmPasswordNode = FocusNode();
  final _btndNode = FocusNode();

  final _nameContoller = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    _confirmPasswordNode.dispose();
    _nameNode.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _btndNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterBloc>(),
      child: Scaffold(
        backgroundColor: context.colors.card,
        body: BgContainer(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = constraints.maxWidth < 600
                    ? 20.w
                    : constraints.maxWidth < 900
                    ? 48.w
                    : 120.w;
                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontal,
                      vertical: 24.h,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildContent(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(25.spMin),
      decoration: BoxDecoration(
        color: AppColors.bootomNav,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizes.spacingXl,
        children: [
          buildHeader(
            'Create Account',
            'Join us and start ordering delicious food',
            Icons.person_add_outlined,
            context,
          ),
          _buildRegisterForm(),
          buildTermsCheckbox(context),
          RegisterButton(btnNode: _btndNode, formKey: _formKey),
          buildSignInLink(context),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUsernameField(_nameNode, _nameContoller, context),
          AppSizes.verticalSpaceMd,
          buildEmailField(_emailNode, _passwordNode, _emailController, context),
          AppSizes.verticalSpaceMd,
          buildPasswordField(
            _passwordNode,
            _confirmPasswordNode,
            _passwordController,
            context,
          ),
          AppSizes.verticalSpaceMd,
          buildConfirmPasswordField(
            _confirmPasswordNode,
            _btndNode,
            _confirmPasswordController,
            context,
          ),
        ],
      ),
    );
  }
}
