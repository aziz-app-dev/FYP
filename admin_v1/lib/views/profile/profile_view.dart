import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/res/app_url/app_url.dart';
import '../../common/res/colors/app_color.dart';
import '../../common/res/components/reuseable_text.dart';
import '../../common/res/components/round_button.dart';
import '../../view models/controllers/login_view_model.dart';

/// Admin account info + server target + logout.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    final user = controller.getUserInfo();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: (user == null || user.profile.isEmpty)
                      ? Container(
                          color: kOffWhite,
                          child: const Icon(Icons.person_outline,
                              size: 40, color: kGrayLight),
                        )
                      : CachedNetworkImage(
                          imageUrl: user.profile,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: kOffWhite,
                            child: const Icon(Icons.person_outline,
                                size: 40, color: kGrayLight),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              ReuseableText(
                text: user?.username ?? 'Super Admin',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                textColor: kDark,
              ),
              const SizedBox(height: 4),
              ReuseableText(
                text: user?.email ?? '',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                textColor: kGray,
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: kRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const ReuseableText(
                  text: 'ADMIN',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  textColor: kRed,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReuseableText(
                text: 'Server',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                textColor: kDark,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.dns_outlined, size: 18, color: kGray),
                  SizedBox(width: 8),
                  Expanded(
                    child: ReuseableText(
                      text: AppUrl.baseUrl,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      textColor: kGray,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ReuseableText(
                text:
                    'Change with --dart-define=BASE_URL=http://<ip>:5000 at build time.',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                textColor: kGrayLight,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        RoundButton(
          title: 'Log out',
          color: kRed,
          onPress: () => controller.logout(),
        ),
      ],
    );
  }
}
