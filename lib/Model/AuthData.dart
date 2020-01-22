class AuthData {
  final String soicalId;
  final String userName;
  final String userPicture;
  final String fcmKey;

  AuthData({this.soicalId, this.userName, this.userPicture, this.fcmKey});

  factory AuthData.fromJson(Map<dynamic, dynamic> data) {
    if (data['result'] == 1) {
      return AuthData(
          soicalId: data['soical_id'],
          userName: data['user_name'],
          userPicture: data['user_picture'],
          fcmKey: data['fcm_key']);
    }
    return null;
  }
}
