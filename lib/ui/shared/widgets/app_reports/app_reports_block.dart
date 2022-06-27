import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:easy_localization/easy_localization.dart';

class AppReportsBlock extends StatelessWidget {
  const AppReportsBlock({
    Key? key,
    this.margin,
    this.padding,
    this.onCrossTap,
    this.onPencilTap,
    this.onSaveButtonTap,
    this.date,
    this.mainText,
    this.imageUrl,
    this.commentCount = 0,
    this.onBlockTap,
    this.isEdit = false,
    this.countComments,
  }) : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Function()? onCrossTap;
  final Function()? onBlockTap;
  final Function()? onPencilTap;
  final Function()? onSaveButtonTap;
  final String? date;
  final String? mainText;
  final String? imageUrl;
  final int? commentCount;
  final String? countComments;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBlockTap,
      child: Container(
        // width: appWidth,
        margin:
            margin ?? EdgeInsets.only(bottom: 15.kH, left: 17.kW, right: 17.kW),
        padding: padding ?? const EdgeInsets.fromLTRB(23, 13, 12, 18),
        decoration: BoxDecoration(
          boxShadow: AppColors.boxShadow,
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  isEdit ? 'Редактирование отчета' : (date ?? 'Нет даты'),
                  style: AppStyles.text11
                      .andWeight(FontWeight.w400)
                      .andColor(AppColors.lightGrey),
                ),
                const Spacer(),
                Row(
                  children: [
                    // if (!isEdit) ...[
                    //   GestureDetector(
                    //     onTap: onPencilTap,
                    //     child: svgPicture(AppIcons.editPencilPath,
                    //         color: AppColors.lightGreyText, height: 13),
                    //   ),
                    //   8.w,
                    // ] else ...[
                    //   AppDiscoloredButton(
                    //     text: 'general.save'.tr(),
                    //     width: 95,
                    //     height: 20,
                    //     onPressed: onSaveButtonTap,
                    //   ),
                    //   20.w,
                    // ],
                    GestureDetector(
                      onTap: onCrossTap,
                      child: svgPicture(AppIcons.closeCrossPath,
                          color: AppColors.lightGreyText, height: 13),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 34.kW),
              child: TextFormField(
                initialValue: mainText ?? 'Текст отсутствует',
                style: AppStyles.text12
                    .andColor(AppColors.plainText)
                    .andWeight(FontWeight.w400)
                    .andHeight(1.3),
                enabled: isEdit,
                maxLines: null,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            5.h,
            if (imageUrl != null) ...[
              Padding(
                padding: EdgeInsets.only(right: 11.kW),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              6.h,
            ],
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onBlockTap,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 3),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.deafGrey,
                        width: 1.0, // Underline thickness
                      ),
                    ),
                  ),
                  child: Text(
                    'general.comments_counter'.tr(args: ['$commentCount']),
                    style: AppStyles.text11
                        .andColor(AppColors.deafGrey)
                        .andWeight(FontWeight.w400),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
