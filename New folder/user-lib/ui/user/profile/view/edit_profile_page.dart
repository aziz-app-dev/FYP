import '../../../../di/service_locator.dart';
import '0_all_profile_view.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final SessionManager _sessionManager = SessionManager();
  late EditProfileBloc _editProfileBloc;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _editProfileBloc = getIt<EditProfileBloc>()..add(LoadProfileEvent());

    final user = _sessionManager.user;
    _nameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _editProfileBloc.close();
    super.dispose();
  }

  void _saveProfile() {
    _editProfileBloc.add(
      UpdateProfileDataEvent(
        username: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocProvider.value(
      value: _editProfileBloc,
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.isSaving != current.isSaving,
        listener: (context, state) {
          // Show success message and pop
          if (state.status == EditProfileStatus.saveSuccess) {
            ToastUtils.showSuccess(
              context,
              message: state.successMessage ?? 'Profile updated successfully',
            );
            Navigator.pop(context);
          }
          // Show error message
          if (state.status == EditProfileStatus.saveError &&
              state.errorMessage != null) {
            ToastUtils.showError(context, message: state.errorMessage!);
          }
        },
        builder: (context, state) {
          final isSaving = state.isSaving;

          return ScreenWrapper(
            mobileHeader: CustomHeader(title: "Edit Profile"),
            mobile: SingleChildScrollView(
              padding: AppSizes.paddingAllMd,
              child: _buildBody(colors, isSaving),
            ),
            // tablet: Center(
            //   child: Padding(
            //     padding: AppSizes.paddingAllMd,
            //     child: SizedBox(
            //       width: 500.spMin,
            //       child: _buildBody(colors, isSaving),
            //     ),
            //   ),
            // ),
            desktop: Center(
              child: Padding(
                padding: AppSizes.paddingAllMd,
                child: SizedBox(
                  width: 450.spMin,
                  child: _buildBody(colors, isSaving),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(ThemeColors colors, bool isSaving) {
    return Column(
      spacing: 20.spMin,
      children: [
        // Profile Avatar with Edit functionality
        Center(
          child: ProfileAvatarWidget(
            size: 130.spMin,
            showEditButton: true,
            showGlow: false,
          ),
        ),

        SizedBox(height: 20.h),

        // Form Fields
        _buildTextField(
          'Full Name',
          _nameController,
          Icons.person_outline,
          colors,
        ),
        _buildTextField(
          'Email',
          _emailController,
          Icons.email_outlined,
          colors,
          enabled: false,
        ),
        _buildTextField(
          'Phone Number',
          _phoneController,
          Icons.phone_outlined,
          colors,
        ),

        SizedBox(height: 20.spMin),
        AppButton(
          width: double.infinity,
          text: 'Save Changes',
          onPressed: isSaving ? () {} : _saveProfile,
          isLoading: isSaving,
        ),
        // Save Button
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    ThemeColors colors, {
    int maxLines = 1,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.spMin),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: colors.primary),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
          ),
          style: AppTextStyles.bodyLarge.copyWith(
            color: enabled ? colors.textPrimary : colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
