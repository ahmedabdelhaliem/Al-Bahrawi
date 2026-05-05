import 'package:al_bahrawi/common/resources/language_manager.dart';
import 'package:al_bahrawi/common/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:al_bahrawi/features/auth/signup/models/signup_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String langKey = 'lang_key';
const String prefsKeyOnBoardingScreenViewed = "PREFS_KEY_ON_BOARDING_SCREEN_VIEWED";
const String prefsKeySaveToken = "PREFS_KEY_SAVE_TOKEN";
const String prefsKeySaveUserType = "PREFS_KEY_SAVE_UserType";
const String prefsKeySaveUserName = "PREFS_KEY_SAVE_Name";
const String prefsKeySaveStudentCode = "PREFS_KEY_SAVE_StudentCode";
const String prefsKeySaveUserImage = "PREFS_KEY_SAVE_UserImage";
const String prefsKeyUserMobile = "PREFS_KEY_USER_mobile";
const String prefsKeyUserEmail = "PREFS_KEY_USER_email";
const String prefsKeyUserId = "PREFS_KEY_USER_ID";
const String prefsKeyUserRole = "PREFS_KEY_USER_Role";



class AppPreferences {

  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  String getAppLanguage() {
    String? language = _sharedPreferences.getString(langKey);
    if(language!=null && language.isNotEmpty)
    {
      return language;
    }
    else
    {
      return LanguageType.ARABIC.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLanguage = getAppLanguage();
    if(currentLanguage == LanguageType.ENGLISH.getValue()){
      _sharedPreferences.setString(langKey, LanguageType.ARABIC.getValue());
    }else{
      _sharedPreferences.setString(langKey, LanguageType.ENGLISH.getValue());
    }
  }

  Future<Locale> getLocale() async {
    String currentLanguage = getAppLanguage();
    if(currentLanguage == LanguageType.ENGLISH.getValue()){
      return ENGLISH_LOCALE;
    }else{
      return ARABIC_LOCALE;
    }
  }

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(prefsKeyOnBoardingScreenViewed, true);
  }

  bool isOnBoardingScreenViewed() {
    return _sharedPreferences.getBool(prefsKeyOnBoardingScreenViewed) ?? false;
  }

  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString(prefsKeySaveToken, token);
  }

  String getToken() {
    return _sharedPreferences.getString(prefsKeySaveToken)??'';
  }

  Future<void> saveUserType(String type) async {
    await _sharedPreferences.setString(prefsKeySaveUserType, type);
  }

  String getUserType() {
    return _sharedPreferences.getString(prefsKeySaveUserType)??'';
  }

  Future<void> saveUserName(String name) async {
    await _sharedPreferences.setString(prefsKeySaveUserName, name);
  }

  String getUserName() {
    return _sharedPreferences.getString(prefsKeySaveUserName)??AppStrings.myCarAuction.tr();
  }

  Future<void> saveStudentCode(String name) async {
    await _sharedPreferences.setString(prefsKeySaveStudentCode, name);
  }

  String getStudentCode() {
    return _sharedPreferences.getString(prefsKeySaveStudentCode)??'';
  }

  Future<void> saveUserImage(String name) async {
    await _sharedPreferences.setString(prefsKeySaveUserImage, name);
  }

  String? getUserImage() {
    return _sharedPreferences.getString(prefsKeySaveUserImage);
  }

  Future<void> setMobile(String mobile) async {
    _sharedPreferences.setString(prefsKeyUserMobile, mobile);
  }

  String getMobile() {
    return _sharedPreferences.getString(prefsKeyUserMobile) ?? '';
  }

  Future<void> setEmail(String email) async {
    _sharedPreferences.setString(prefsKeyUserEmail, email);
  }

  String getEmail() {
    return _sharedPreferences.getString(prefsKeyUserEmail) ?? '';
  }

  Future<void> setUserRole(UserRole role) async {
    await _sharedPreferences.setString(prefsKeyUserRole, role.name);
  }

  UserRole getUserRole() {
    String roleName = _sharedPreferences.getString(prefsKeyUserRole) ?? 'user';
    return UserRole.values.firstWhere((e) => e.name == roleName, orElse: () => UserRole.user);
  }

  Future<void> setIsOfficeClient(bool isOfficeClient) async {
    await _sharedPreferences.setBool("PREFS_KEY_IS_OFFICE_CLIENT", isOfficeClient);
  }

  bool isOfficeClient() {
    return _sharedPreferences.getBool("PREFS_KEY_IS_OFFICE_CLIENT") ?? false;
  }

  Future<void> setUserId(int userId) async {
    _sharedPreferences.setInt(prefsKeyUserId, userId);
  }
  int getUserId() {
    return _sharedPreferences.getInt(prefsKeyUserId) ?? 0;
  }

   Future<void> logout() async {
    await Future.wait([
      _sharedPreferences.remove(prefsKeySaveToken),
      _sharedPreferences.remove(prefsKeySaveUserType),
      _sharedPreferences.remove(prefsKeySaveUserName),
      _sharedPreferences.remove(prefsKeySaveStudentCode),
      _sharedPreferences.remove(prefsKeySaveUserImage),
     _sharedPreferences.remove(prefsKeyUserEmail),
     _sharedPreferences.remove(prefsKeyUserMobile),
     _sharedPreferences.remove(prefsKeyUserId),
     _sharedPreferences.remove(prefsKeyUserRole),
     _sharedPreferences.remove("PREFS_KEY_IS_OFFICE_CLIENT"),
    ]);
  }

}
