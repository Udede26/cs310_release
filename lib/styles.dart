import 'package:flutter/material.dart';
import 'package:flutter_app/colors.dart';

class styles {
  static const BarTitleTextStyle = TextStyle(
    color: AppColors.mainTexts,
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
    letterSpacing: -0.6,
  ); //En üstteki başlıklar

  static const NotificationsButtonTextStyle = TextStyle(
    color: AppColors.mainTexts,
    fontWeight: FontWeight.w300,
    fontSize: 13.0,
    letterSpacing: -0.6,
  ); //Accept or Deelete

  static const HeadingTitleTextStyle = TextStyle(
    color: AppColors.mainTexts,
    fontWeight: FontWeight.w600,
    fontSize: 23.0,
    letterSpacing: -0.6,
  ); //Butun pagelerin küçük başlıkları için

  static const minorTextStyle = TextStyle(
    color: AppColors.subTexts,
    fontWeight: FontWeight.w300,
    fontSize: 13.0,
    letterSpacing: -0.6,
  ); //Kalan tüm textler: commentler,bildirimler,following-followers page, my profile page,edit profile page, Settings, App, Blocked Accounts,Privacy Page,Notifications Settings Page,Language Page

  static const WelcomeTitleTextStyle = TextStyle(
    color: AppColors.mainTexts,
    fontWeight: FontWeight.w900,
    fontSize: 20.0,
    letterSpacing: -0.6,
  ); //Aynı zamanda Login Page title

  static const WelcomeButtonTextStyle = TextStyle(
    color: AppColors.mainTexts,
    fontWeight: FontWeight.w500,
    fontSize: 23.0,
    letterSpacing: -0.6,
  ); //Aynı zamanda Login Page 'Username or Email - Password text ve Enter button, Change Password-Username Button, Language Page Apply button

  static const SearchButtonTextStyle = TextStyle(
    color: AppColors.subTexts,
    fontWeight: FontWeight.w100,
    fontSize: 13.0,
    letterSpacing: -0.6,
  ); //Aynı zamanda Change Password,Change Username blank parts,Privacy buttons,Language page buttons

  static const EditProfilePageTextStyle = TextStyle(
    color: AppColors.mainTexts,
    fontWeight: FontWeight.w300,
    fontSize: 13.0,
    letterSpacing: -0.6,
  ); //Settings, Done, Change Profile Photo
}
