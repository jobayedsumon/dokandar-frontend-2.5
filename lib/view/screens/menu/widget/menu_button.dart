import 'package:dokandar/controller/auth_controller.dart';
import 'package:dokandar/controller/cart_controller.dart';
import 'package:dokandar/controller/splash_controller.dart';
import 'package:dokandar/controller/user_controller.dart';
import 'package:dokandar/controller/wishlist_controller.dart';
import 'package:dokandar/data/model/response/menu_model.dart';
import 'package:dokandar/helper/responsive_helper.dart';
import 'package:dokandar/helper/route_helper.dart';
import 'package:dokandar/util/dimensions.dart';
import 'package:dokandar/util/images.dart';
import 'package:dokandar/util/styles.dart';
import 'package:dokandar/view/base/confirmation_dialog.dart';
import 'package:dokandar/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dokandar/view/screens/auth/sign_in_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MenuButton extends StatelessWidget {
  final MenuModel menu;
  final bool isProfile;
  final bool isLogout;
  const MenuButton({Key? key, required this.menu, required this.isProfile, required this.isLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int count = ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4;
    double size = ((context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth : context.width)/count)-Dimensions.paddingSizeDefault;

    return InkWell(
      onTap: () async {
        if(isLogout) {
          Get.back();
          if(Get.find<AuthController>().isLoggedIn()) {
            Get.dialog(ConfirmationDialog(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
              Get.find<UserController>().clearUserInfo();
              Get.find<AuthController>().clearSharedData();
              Get.find<AuthController>().socialLogout();
              Get.find<CartController>().clearCartList();
              Get.find<WishListController>().removeWishes();
              if(!ResponsiveHelper.isDesktop(context)) {
                Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
              } else{
                Get.dialog(const SignInScreen(exitFromApp: true, backFromThis: true));
              }
            }), useSafeArea: false);
          }else {
            if (!ResponsiveHelper.isDesktop(context)) {
              Get.find<WishListController>().removeWishes();
              Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
            } else{
              Get.dialog(const SignInScreen(exitFromApp: true, backFromThis: true));
            }
          }
        }else if(menu.route.startsWith('http')) {
          if(await canLaunchUrlString(menu.route)) {
            launchUrlString(menu.route, mode: LaunchMode.externalApplication);
          }
        }else {
          Get.offNamed(menu.route);
        }
      },
      child: Column(children: [

        Container(
          height: size-(size*0.2),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: isLogout ? Get.find<AuthController>().isLoggedIn() ? Colors.red : Colors.green : Theme.of(context).primaryColor,
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
          ),
          alignment: Alignment.center,
          child: isProfile ? ProfileImageWidget(size: size) : Image.asset(menu.icon, width: size, height: size, color: Colors.white),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(menu.title, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),

      ]),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final double size;
  const ProfileImageWidget({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: Colors.white)),
        child: ClipOval(
          child: CustomImage(
            image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                '/${(userController.userInfoModel != null && Get.find<AuthController>().isLoggedIn()) ? userController.userInfoModel!.image ?? '' : ''}',
            width: size, height: size, fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}

