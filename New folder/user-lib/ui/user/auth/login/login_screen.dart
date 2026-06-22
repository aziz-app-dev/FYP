import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../../../config/widgets/app_btn.dart';
import '../../../../ui/user/auth/widgets/auth_header.dart';
import '../../../../bloc/user/login/login_bloc.dart';
import '../../../../bloc/user/login/login_state.dart';
import '../../../../config/config.dart';
import '../../../../di/service_locator.dart';
import '../../../../routes/route_name.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/utils.dart';
import 'widgets/eamil_field.dart';
import 'widgets/login_btn.dart';
import 'widgets/password_field.dart';
import 'widgets/remember_check.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailNode = FocusNode();
  final _passNode = FocusNode();
  final _btnNode = FocusNode();
  final _emailContoller = TextEditingController(
    text: 'azizrahmang589@gmail.com',
  );
  final _passContoller = TextEditingController(text: '11223344');

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = getIt<LoginBloc>();

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
    _emailNode.dispose();
    _passNode.dispose();
    _btnNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _loginBloc,
      child: Builder(
        builder: (context) {
          return BlocBuilder<LoginBloc, LoginState>(
            buildWhen: (previous, current) =>
                previous.loginResponse.status != current.loginResponse.status,
            builder: (context, state) {
              final isLoading = state.loginResponse.status == Status.loading;
              return Scaffold(
                backgroundColor: context.colors.card,
                body: BgContainer(
                  child: AbsorbPointer(
                    absorbing: isLoading,
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
            },
          );
        },
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
            'Welcome Back!',
            'Sign in to continue your food journey',
            Icons.restaurant_menu,
            context,
          ),
          AppSizes.verticalSpaceXs,
          _buildLoginForm(),
          LoginButton(btnNode: _btnNode, formKey: _formKey),
          _buildDivider(),
          _buildSocialLogin(),
          _buildSignUpLink(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailField(_emailNode, _passNode, _emailContoller, context),
          AppSizes.verticalSpaceMd,
          buildPasswordField(_passNode, _btnNode, _passContoller, context),
          RememberMeAndForgot(),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: context.colors.border)),
        Padding(
          padding: AppSizes.paddingHorizontalMd,
          child: Text('Or continue with', style: AppTextStyles.bodySmall),
        ),
        Expanded(child: Divider(color: context.colors.border)),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return AppButton(
      width: double.infinity,
      backgroundColor: Colors.transparent,
      borderColor: context.colors.primary,
      textColor: context.colors.textPrimary,
      borderWidth: 1.5,
      icon: TablerIcons.brand_google,
      text: "Google",
      onPressed: () {
        ToastUtils.showInfo(context, message: "Comeing Soon!");
      },
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              "Don't have an account? ",
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteName.register);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Sign Up',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
