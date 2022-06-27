import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';

import 'app_comments_model.dart';

class AppCommentsBlock extends StatelessWidget {
  const AppCommentsBlock(
      {Key? key,
      required this.list,
      required this.controller,
      required this.onSend,
      this.margin,
      this.showInput = true,
      this.isDivider = true,
      this.canDelete = false,
      required this.onReply})
      : super(key: key);

  final List<AppCommentsModel> list;
  final TextEditingController? controller;
  final Function() onSend;
  final EdgeInsets? margin;
  final bool showInput;
  final bool isDivider;
  final Function(List<String> userName, int commentId, int? parentCommentIndex)
      onReply;
  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: (margin != null)
          ? margin
          : EdgeInsets.fromLTRB(23.kW, 0, 23.kW, 10.kH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDivider) const Divider(),
          4.h,
          SimpleRichText(
            'settings.comments'.tr(),
            post: TextSpan(
                text: '  (${list.length})',
                style: AppStyles.text12.andColor(AppColors.plainText)),
            style: AppStyles.text14.andWeight(FontWeight.bold),
          ),
          15.h,
          _ListComments(
            list: list,
            length: list.length,
            controller: controller,
            onReply: onReply,
            canDelete: canDelete,
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 23.kW,
                      vertical: 23.kH,
                    ),
                    child: _ListComments(
                      list: list,
                      length: list.length,
                      controller: controller,
                      onReply: onReply,
                      canDelete: canDelete,
                    ),
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 40),
              child: Text(
                'general.show_all_comments'.tr(),
                style: AppStyles.text11
                    .andWeight(FontWeight.w300)
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ),
          13.h,
          //Условие для летающего поля для ввода
          showInput
              ? AppInput(
                  hintText: 'general.your_comments'.tr(),
                  iconData: Icons.arrow_forward,
                  margin: const EdgeInsets.all(0),
                  controller: controller,
                  onIconTap: onSend,
                )
              : Container(
                  height: 50,
                ),
        ],
      ),
    );
  }
}

class _ListComments extends StatelessWidget {
  const _ListComments({
    Key? key,
    required this.list,
    required this.length,
    required this.controller,
    required this.onReply,
    this.canDelete = false,
  }) : super(key: key);

  final List<AppCommentsModel> list;
  final int length;
  final TextEditingController? controller;
  final Function(List<String> userNames, int commentId, int? parentCommentIndex)
      onReply;
  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Container();
    } else {
      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (_, i) {
          return _Comment(
            comment: list[i],
            onReply: onReply,
            canDelete: canDelete,
            parentIndex: i,
          );
        },
      );
    }
  }
}

class _Comment extends StatelessWidget {
  const _Comment({
    Key? key,
    required this.comment,
    required this.onReply,
    required this.parentIndex,
    this.canDelete = false,
  }) : super(key: key);

  final Function(List<String> userNames, int commentId, int? parentCommentIndex)
      onReply;
  final AppCommentsModel comment;
  final bool canDelete;
  final int parentIndex;

  @override
  Widget build(BuildContext context) {
    final replies = comment.replies?.isNotEmpty ?? false;
    return Container(
        margin: EdgeInsets.only(bottom: 14.kH),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppAvatarBlock(
            radius: 15.5,
            path: comment.avatarPath ?? '',
          ),
          9.w,
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                  children: [
                    Text(
                      comment.name,
                      style: AppStyles.text12.andWeight(FontWeight.w500),
                    ),
                    if (canDelete) ...[
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {},
                          child: svgPicture(AppIcons.closeCrossPath,
                              color: AppColors.lightGreyText, height: 11),
                        ),
                      ),
                    ]
                  ],
                ),
                4.h,
                Text(
                  comment.content,
                  style: AppStyles.text11
                      .andWeight(FontWeight.w300)
                      .andHeight(1.4),
                  softWrap: true,
                ),
                4.h,
                GestureDetector(
                  child: SimpleRichText(
                    comment.date,
                    post: TextSpan(
                        text: 'general.answer'.tr(),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => comment.answerer != null
                              ? onReply([comment.name, comment.answerer!],
                                  comment.id, parentIndex)
                              : onReply(
                                  [comment.name], comment.id, parentIndex),
                        style: AppStyles.text11.andColor(AppColors.link)),
                    style: AppStyles.text11
                        .andWeight(FontWeight.w300)
                        .andHeight(1.4)
                        .andColor(AppColors.lightGreyText),
                  ),
                ),
                replies
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemCount: comment.replies!.length,
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              final repliesList = comment.replies!;
                              return _Comment(
                                  parentIndex: parentIndex,
                                  comment: repliesList[index],
                                  //Так как глубина вложенности 2, то при ответе, мы отвечаем на родительскй комментарий
                                  onReply: (userName, commentId, parentIndex) =>
                                      onReply(
                                          userName, commentId, parentIndex));
                            }),
                      )
                    : Container()
              ]))
        ]));
  }
}
