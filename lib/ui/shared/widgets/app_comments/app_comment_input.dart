import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';

class CommentInput extends StatelessWidget {
  const CommentInput({
    required this.showReply,
    required this.showMention,
    required this.replyNames,
    required this.users,
    required this.insertUserName,
    required this.controller,
    required this.addComment,
    Key? key,
  }) : super(key: key);

  final bool showReply;
  final bool showMention;
  final String replyNames;
  final List<UserInfo> users;
  final Function(String) insertUserName;
  final TextEditingController controller;
  final Function() addComment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          showReply ? _UserReply(userName: replyNames) : Container(),
          showMention ? _UserMention(users, insertUserName) : Container(),
          SizedBox(
            height: 33,
            child: AppInput(
              hintText: 'general.your_comments'.tr(),
              iconData: Icons.arrow_forward,
              margin: const EdgeInsets.all(0),
              controller: controller,
              onIconTap: addComment,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserReply extends StatelessWidget {
  const _UserReply({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        color: AppColors.semiPurple,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Text(
              'general.your_answer_user'.tr(args: [userName]),
              style: AppStyles.text11.andColor(AppColors.plainText),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _UserMention extends StatelessWidget {
  const _UserMention(this.users, this.insertUserName, {Key? key})
      : super(key: key);

  final List<UserInfo> users;
  final Function(String) insertUserName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: AppColors.boxShadow,
        color: AppColors.white,
      ),
      padding: const EdgeInsets.fromLTRB(9, 6.25, 9, 3.5),
      child: ListView.builder(
          itemCount: users.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            UserInfo currentUser = users[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () =>
                      insertUserName(getFullUserNameWithMention(currentUser)),
                  child: Row(
                    children: [
                      AppAvatarBlock(
                        path: currentUser.photo.getOrElse(),
                        radius: 15.5,
                      ),
                      6.w,
                      Text(
                        getFullUserNameWithMention(currentUser),
                        style: AppStyles.text12
                            .andWeight(FontWeight.w500)
                            .andColor(AppColors.plainText),
                      )
                    ],
                  ),
                ),
                4.25.h,
              ],
            );
          }),
    );
  }

  String getFullUserNameWithMention(UserInfo user) {
    return '@${user.firstName.getOrElse()}${user.lastName.getOrElse()}';
  }
}
