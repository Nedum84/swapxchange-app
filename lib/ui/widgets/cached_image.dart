import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/models/tokens.dart';
import 'package:swapxchange/ui/widgets/question_mark.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';
import 'package:swapxchange/utils/user_prefs.dart';

const QUESTION_MARK2 = 'https://assets.stickpng.com/thumbs/5a461418d099a2ad03f9c999.png';
const QUESTION_MARK = 'https://images.emojiterra.com/google/android-11/512px/2754.png';
const NO_IMAGE = "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";
const USER = "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png";

class CachedImage extends StatelessWidget {
  final String? imageUrl;
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

  Widget _altWidget() {
    Widget altView;

    switch (this.alt) {
      // case ImagePlaceholder.NoImage:
      //   altView = Container();
      //   break;
      case ImagePlaceholder.User:
        altView = ClipRRect(
          borderRadius: BorderRadius.circular(isRound ? 50 : radius),
          child: Container(
            height: isRound ? radius : height,
            width: isRound ? radius : width,
            color: KColors.TEXT_COLOR.withOpacity(.1),
            padding: EdgeInsets.all(2),
            child: Icon(
              Icons.person,
              color: Colors.black26,
            ),
          ),
        );
        break;
      case ImagePlaceholder.QuestionMark:
        altView = QuestionMark(
          height: isRound ? radius : height,
          width: isRound ? radius : width,
          radius: isRound ? 50 : radius,
        );
        break;
      default:
        altView = ClipRRect(
          borderRadius: BorderRadius.circular(isRound ? 50 : radius),
          child: Container(
            height: isRound ? radius : height,
            width: isRound ? radius : width,
            color: KColors.TEXT_COLOR.withOpacity(.1),
            padding: EdgeInsets.all(2),
            child: Center(
              child: Text(
                'LOADING...',
                style: StyleNormal.copyWith(
                  color: Colors.black26,
                ),
              ),
            ),
          ),
        );
    }

    return altView;
  }

  @override
  Widget build(BuildContext context) {
    try {
      return InkWell(
        onTap: onClick,
        child: SizedBox(
          height: isRound ? radius : height,
          width: isRound ? radius : width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isRound ? 50 : radius),
            child: FutureBuilder<Tokens?>(
              future: UserPrefs.getTokens(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final tokens = snapshots.data!;
                final token = tokens.access?.token;
                return imageUrl == null || imageUrl!.isEmpty
                    ? _altWidget()
                    : !imageUrl!.contains('http') //For file images, use file image
                        ? Image.file(
                            File(imageUrl!),
                            fit: fit,
                          )
                        : CachedNetworkImage(
                            imageUrl: imageUrl!,
                            fit: fit,
                            httpHeaders: {'Authorization': "Bearer $token"},
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) {
                              return Image.network(
                                imageUrl ?? "",
                                fit: fit,
                                headers: {'Authorization': "Bearer $token"},
                              );
                            },
                          );
              },
            ),
          ),
        ),
      );
    } catch (e) {
      // print(e);
      return _altWidget();
    }
  }
}

enum ImagePlaceholder { QuestionMark, NoImage, User }
