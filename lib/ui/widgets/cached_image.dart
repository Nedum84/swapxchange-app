import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/ui/widgets/shimmer_block.dart';
import 'package:swapxchange/utils/colors.dart';

const QUESTION_MARK2 = 'https://assets.stickpng.com/thumbs/5a461418d099a2ad03f9c999.png';
const QUESTION_MARK = 'https://images.emojiterra.com/google/android-11/512px/2754.png';
const NO_IMAGE = "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";
const USER = "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png";

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;
  final double? height;
  final double? width;
  final Function()? onClick;

  final BoxFit fit;
  final ImagePlaceholder alt;

  CachedImage(
    this.imageUrl, {
    this.isRound = false,
    this.radius = 0,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.alt = ImagePlaceholder.NoImage,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    String alt;
    switch (this.alt) {
      case ImagePlaceholder.NoImage:
        alt = NO_IMAGE;
        break;
      case ImagePlaceholder.User:
        alt = USER;
        break;
      case ImagePlaceholder.QuestionMark:
        alt = QUESTION_MARK;
        break;
      default:
        alt = NO_IMAGE;
    }

    try {
      return SizedBox(
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isRound ? 50 : radius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: fit,
            placeholder: (context, url) => Center(child: ShimmerBlock()),
            errorWidget: (context, url, error) => ClipRRect(
              borderRadius: BorderRadius.circular(isRound ? 50 : radius),
              child: Image.network(
                alt,
                height: isRound ? radius : height,
                width: isRound ? radius : width,
                fit: fit,
                color: KColors.WHITE_GREY2,
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      print(e);
      return ClipRRect(
        borderRadius: BorderRadius.circular(isRound ? 50 : radius),
        child: Image.network(
          alt,
          height: isRound ? radius : height,
          width: isRound ? radius : width,
          fit: fit,
          color: KColors.TEXT_COLOR_LIGHT2,
        ),
      );
    }
  }
}

enum ImagePlaceholder { QuestionMark, NoImage, User }
