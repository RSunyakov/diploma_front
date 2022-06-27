import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppAvatarBlock extends StatelessWidget {
  const AppAvatarBlock({
    Key? key,
    required this.path,
    this.color,
    this.radius,
    this.file,
    this.emptyAvatarPath,
    this.isMentor,
  }) : super(key: key);

  final String path;
  final Color? color;
  final double? radius;
  final File? file;
  final String? emptyAvatarPath;
  final bool? isMentor;

  @override
  Widget build(BuildContext context) {
    const defaultRadius = 17.5;
    final r = radius ?? defaultRadius;
    final d = r * 2;
    return path != ''
        ? Container(
            height: d,
            width: d,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r),
              color: color ?? AppColors.branded,
            ),
            child: file != null && file!.path.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(r),
                    child: Image.file(
                      file!,
                      fit: BoxFit.cover,
                      width: d,
                      height: d,
                    ),
                  )
                : isMentor != null && isMentor!
                    ? Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          _Avatar(r: r, path: path),
                          Positioned(child: svgPicture(AppIcons.mentorLogo))
                        ],
                      )
                    : _Avatar(r: r, path: path))
        : svgPicture(emptyAvatarPath ?? AppIcons.emptyAvatar,
            height: d, width: d);
  }
}

class _Avatar extends StatelessWidget {
  final double r;
  final String path;

  const _Avatar({
    Key? key,
    required this.r,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: FadeInImage.assetNetwork(
        fit: BoxFit.cover,
        placeholder: AppIcons.iconLoaderGif,
        image: path,
        imageScale: 2,
        imageErrorBuilder: (context, url, error) => const Icon(
          Icons.image_not_supported,
          color: AppColors.red,
        ),
      ),
    );
  }
}
