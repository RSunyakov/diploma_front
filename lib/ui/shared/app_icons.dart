import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcons {
  static String ruPath = "assets/images/RU.svg";
  static String frPath = "assets/images/FR.svg";
  static String italPath = "assets/images/IT.svg";
  static String englandPath = "assets/images/GB.svg";
  static String espPath = "assets/images/ES.svg";

  static String viaFaceIdPath = 'assets/images/via_face_id.svg';
  static Widget viaFaceId = SvgPicture.asset(viaFaceIdPath);

  static const AssetImage profileIcon =
      AssetImage('assets/images/proxy_profile_image.png');
  static const AssetImage sunIcon = AssetImage('assets/images/sun.png');
  static const AssetImage starsIcon =
      AssetImage('assets/images/proxy_stars.png');
  static const AssetImage profileMentorIcon =
      AssetImage('assets/images/mentorUser.png');
  static const AssetImage loopIcon = AssetImage('assets/images/loop.png');

  //
  static const String news = 'assets/images/icon_lenta.png';
  static const String activeNews = 'assets/images/icon_lenta_select.png';
  static const String metaLife = 'assets/images/icon_meta.png';
  static const String activeMetaLife = 'assets/images/icon_meta_select.png';
  static const String goals = 'assets/images/icon_goals.png';
  static const String activeGoals = 'assets/images/icon_goals_select.png';
  static const String mentor = 'assets/images/icon_mentor.png';
  static const String activeMentor = 'assets/images/icon_mentor_select.png';
  static const String profile = 'assets/images/icon_profile.png';
  static const String activeProfile = 'assets/images/icon_profile_select.png';

  static const String sphereIconPath = "assets/images/ic_sphere.svg";
  static const String sphereTextPath = "assets/images/text_sphere.svg";
  static const String faceIdIconPath = "assets/images/icon_face_id.svg";
  static const String bellIconPath = "assets/images/bell.svg";
  static const String settingsIconPath = "assets/images/settings.svg";
  static const String sunIconPath = "assets/images/sun.svg";
  static const String starsIconPath = "assets/images/proxy_stars.svg";
  static const String dreamBalloonPath = "assets/images/icon_dream_balloon.svg";
  static const String medalPath = "assets/images/icon_medal.svg";
  static const String mentoringPath = "assets/images/icon_mentoree.svg";
  static const String biPeoplePath = "assets/images/icon_bi_people.svg";
  static const String placePath = "assets/images/icon_place.svg";
  static const String capPath = "assets/images/icon_cap.svg";
  static const String portfPath = "assets/images/icon_portf.svg";
  static const String hobbyPath = "assets/images/icon_hobby.svg";
  static const String noImage = "assets/images/image_not_found.svg";
  static const String progressArrow = "assets/images/progress_arrow.svg";
  static const String bigArrow = "assets/images/big_arrow.svg";
  static const String rightArrow = "assets/images/right_arrow.svg";
  static const String leftArrow = "assets/images/left_arrow.svg";
  static const String starIconPath = "assets/images/icon_star_non_pressed.svg";
  static const String starPressedIconPath =
      "assets/images/icon_star_pressed.svg";
  static const String edit = "assets/images/edit.svg";
  static const String plus = "assets/images/plus.svg";
  static const String calendar = "assets/images/calendar.svg";
  static const String studyHatPath = "assets/images/study_hat.svg";
  static const String editPencilPath = "assets/images/edit_pencil.svg";
  static const String closeCrossPath = "assets/images/close_cross.svg";
  static const String reportsCrossPath = "assets/images/reports_cross.svg";
  static const String arrowUp = 'assets/images/arrow_up.svg';
  static const String gallery = 'assets/images/gallery.svg';
  static const String camera = 'assets/images/camera.svg';
  static const String arrowDown = 'assets/images/arrow_down.svg';
  static const String arrowDownGrey = 'assets/images/arrow_down_grey.svg';
  static const String fingerPath = 'assets/images/finger_icon.svg';
  static const String copyPath = 'assets/images/copy_icon.svg';
  static const String cupPath = 'assets/images/kubok_icon.svg';
  static const String searchLoupePath = "assets/images/search_loupe.svg";
  static const String phone = 'assets/images/phone.svg';
  static const String arrowForwardSharp =
      'assets/images/arrow_forward_sharp.svg';
  static const String reportsClip = 'assets/images/reports_clip.svg';
  static const AssetImage location = AssetImage('assets/images/location.png');
  static const AssetImage checkboxOnPng =
      AssetImage('assets/images/checkbox_on.png');
  static const AssetImage checkboxOffPng =
      AssetImage('assets/images/checkbox_off.png');
  static const String iconStudyPath = "assets/images/icon_study.svg";
  static const String iconWorkPath = "assets/images/icon_work.svg";
  static const String iconHobbyPath = "assets/images/icon_hobby.svg";
  static const String iconAttachedPath = "assets/images/icon_attached.svg";
  static const String iconStudentsPath = "assets/images/students.svg";
  static const String iconSphereCoin = "assets/images/sphere_coin.svg";
  static const String iconDone = "assets/images/done.svg";
  static const String iconBack = "assets/images/arrow_back.svg";
  static const String close = "assets/images/close.svg";
  static const String questionAvatar = "assets/images/question_avatar.svg";
  static const String mentorLogo = "assets/images/mentor_logo.svg";
  static const String createGoalClose = "assets/images/create_goal_cancel.svg";
  static const String info = "assets/images/info.svg";
  static const String groupGoal = "assets/images/group_goal.png";
  static const String privateGoal = "assets/images/private_goal.svg";
  static const String arrowRight = "assets/images/arrow_right.svg";

  //navigation navBAr
  static const String navLenta = "assets/images/nav_lenta.svg";
  static const String navLentaActive = "assets/images/nav_lenta_active.svg";

  static const String emptyAvatar = "assets/images/empty_avatar.svg";
  static const String emptyAvatarBig = "assets/images/empty_avatar_big.svg";
  static const String iconFilterPng = "assets/images/icon-filter.png";
  static const String iconLoaderGif = "assets/images/loader.gif";
  static const String sliderTooltip = "assets/images/slider_tooltip.svg";
}

Widget svgPicture(
  String path, {
  double? height,
  double? width,
  Color? color,
  BoxFit? fit,
  Function()? onTap,
  bool isNotSvg = false,
}) =>
    GestureDetector(
      onTap: onTap,
      child: isNotSvg
          ? Image.asset(
              path,
              height: height,
              width: width,
              color: color,
              fit: fit ?? BoxFit.contain,
            )
          : SvgPicture.asset(
              path,
              height: height,
              width: width,
              color: color,
              fit: fit ?? BoxFit.contain,
            ),
    );
