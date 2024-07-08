import 'package:cached_network_image/cached_network_image.dart';
import 'package:dokandar/util/images.dart';
import 'package:flutter/cupertino.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;
  const CustomImage({Key? key, required this.image, this.height, this.width, this.fit = BoxFit.cover, this.isNotification = false, this.placeholder = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image customPlaceHolder = Image.asset(placeholder.isNotEmpty ? placeholder : isNotification ? Images.notificationPlaceholder : Images.placeholder, height: height, width: width, fit: fit);
    return !image.endsWith('null') ? CachedNetworkImage(
      imageUrl: image, height: height, width: width, fit: fit,
      placeholder: (context, url) => customPlaceHolder,
      errorWidget: (context, url, error) => customPlaceHolder,
    ) : customPlaceHolder;
  }
}
