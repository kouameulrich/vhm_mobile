class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://backendvhm.azurewebsites.net/";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String sendMembers = 'api/EventMember/mobileAdd';

  static const String sendNewMembers = 'api/Member/add';

  static const String AddEnventGuest = '/api/EventGuest/AddEventGuestByMobile';
}
