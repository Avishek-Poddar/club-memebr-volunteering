import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Consts.dart';

const baseUrl = Consts.BASE_URL;

class API {
  static Future getCms() {
    var url = baseUrl + "cms";
    return http.get(url);
  }

  static Future updateCMS(String value) {
    var url = baseUrl + "cms";
    var body = {'policies': value};
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future sendMessage(int userId, int otherId, String message) {
    var url = baseUrl + "chats/${userId}/${otherId}";
    var body = {
      'sender_id': "${userId}",
      'receiver_id': "${otherId}",
      'message': message
    };
    print(body);
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      print(response.body);

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future forgotPassword(String email) {
    var url = baseUrl + "forgot";
    var body = {'email': email};
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      print(response.body);

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future getEvents({userId}) {
    var url = baseUrl + "events";
    if (userId != null) {
      url = baseUrl + "events/${userId}";
    }
    return http.get(url);
  }

  static Future getRequests() {
    var url = baseUrl + "requests";
    return http.get(url);
  }

  static Future applyEvents(int userId, int eventId) {
    var url = baseUrl + "apply/event/${eventId}/user/${userId}";
    return http.get(url);
  }

  static Future acceptRequest(int userId, int eventId) {
    var url = baseUrl + "accept/event/${eventId}/user/${userId}";
    print(url);
    return http.get(url);
  }

  static Future denyRequest(int userId, int eventId) {
    var url = baseUrl + "deny/event/${eventId}/user/${userId}";
    return http.get(url);
  }

  static Future getActivities() {
    var url = baseUrl + "activities";
    return http.get(url);
  }

  static Future getUsers() {
    var url = baseUrl + "users";
    return http.get(url);
  }

  static Future getUser(int id) async {
    var url = baseUrl + "user/${id}";
    return http.get(url);
  }

  static Future getChatHistory(int id) async {
    var url = baseUrl + "user/${id}/history";
    return http.get(url);
  }

  static Future getChats(int id, int other) async {
    var url = baseUrl + "chats/${id}/${other}";
    return http.get(url);
  }

  static Future getAdmins() {
    var url = baseUrl + "admins";
    return http.get(url);
  }

  static Future addEvents(Map body) {
    var url = baseUrl + "event";
    body.remove('id');
    body.remove('status');

    print(body);

    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      print(response.body);

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future updateEvents(int eventId, Map body) {
    var url = baseUrl + "event/${eventId}/update";
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future deleteEvents(int id) {
    var url = baseUrl + "event/${id}/delete";
    return http.get(url);
  }

  static Future deleteAdmin(int id) {
    var url = baseUrl + "admin/${id}/delete";
    return http.get(url);
  }

  static Future deleteUser(int id) {
    var url = baseUrl + "user/${id}/delete";
    return http.get(url);
  }

  static Future addAdmin(Map body) {
    var url = baseUrl + "admin";
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future updateAdmin(int id, Map body) {
    var url = baseUrl + "admin/${id}/update";
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future updateUser(int id, Map body) {
    var url = baseUrl + "user/${id}/update";
    print(url);
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      print(response.body);

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future updatePassword(int id, String oldPassword, String newPassword) {
    var url = baseUrl + "user/${id}/password";

    Map<String, String> body = {
      'old_password': "${oldPassword}",
      'new_password': "${newPassword}"
    };

    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future inviteUser(String email) {
    var url = baseUrl + "invite";
    var body = new Map<String, String>();
    body['email'] = email;
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);

      return new APIResponse(map['status'], map['msg'], map['data']);
    });
  }

  static Future getMyEvents(int id) {
    var url = baseUrl + "users/${id}/get/events";
    return http.get(url);
  }

  static Future getMyHours(int id) {
    var url = baseUrl + "users/${id}/get/hours";
    return http.get(url);
  }

  static Future getHours() {
    var url = baseUrl + "hours";
    return http.get(url);
  }
}

class APIResponse {
  bool status;
  String msg;
  dynamic data;

  APIResponse(this.status, this.msg, this.data);
}
