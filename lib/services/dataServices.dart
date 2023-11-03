import 'dart:async';
import 'dart:convert';
import 'package:voting_flutter/api/net_api.dart';
import 'package:voting_flutter/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';

class DataService {
  Map<String, String> headers = {};
  final cookieJar = CookieJar();


  void updateCookie(http.Response response) {
    response.headers.forEach((key, value) {
      print('Key = ${key}, Value= ${value}');
    });
    String? rawCookie = response.headers['set-cookie'];
    print(rawCookie);
    String? rawCookie2 = response.headers['Set-Cookie'];
    print(rawCookie2);
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
      print(headers['cookie'] );
    }
  }

  Future<UserInfo> GetUserInfo() async {
    final response = await getUserInfo();
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _userinfo = new UserInfo.fromJson(_jsonString);
      return _userinfo;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<OnlyMyMeeting> GetLastMeeting() async {
    final response = await getLastMeeting(); //
    // updateCookie(response);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _meeting = new OnlyMyMeeting.fromJson(_jsonString);
      return _meeting;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Meeting> GetAdminLastMeeting() async {
    final response = await getLastAdminMeeting(); //
    try {
      // updateCookie(response);
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _meeting = new Meeting.fromJson(_jsonString);
      return _meeting;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<RegistrationBallot> UpdateRegistrationBallot(ballot) async {

    final response = await updateRegistration(ballot);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _registrationBallot = new RegistrationBallot.fromJson(_jsonString);
      return _registrationBallot;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<VoteBallot> UpdateVoteBallot(ballot) async {

    final response = await updateVote(ballot);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _voteBallot = new VoteBallot.fromJson(_jsonString);
      return _voteBallot;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<RegistrationBallot> ReloadRegistrationBallot(ballot) async {
    final response = await fetchRegistration(ballot);
    // updateCookie(response);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _registrationBallot = new RegistrationBallot.fromJson(_jsonString);
      return _registrationBallot;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<VoteBallot> ReloadVoteBallot(ballot) async {
    final response = await fetchVote(ballot);
    // updateCookie(response);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _voteBallot = new VoteBallot.fromJson(_jsonString);
      return _voteBallot;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<OnlyMyRegistrationProcess> ReloadOnlyMyRegistrationProcess(
      process) async {
    final response = await fetchMyRegistrationProcess(process);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _registrationProcess =
          new OnlyMyRegistrationProcess.fromJson(_jsonString);
      return _registrationProcess;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<OnlyMyVotingProcess> ReloadOnlyMyVotingProcess(
      process) async {
    final response = await fetchMyVotingProcess(process);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _votingProcess =
          new OnlyMyVotingProcess.fromJson(_jsonString);
      return _votingProcess;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<RegistrationProcess> ReloadAdminRegistrationProcess(
      process) async {
    final response = await fetchRegistrationProcess(process);
    // updateCookie(response);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _registrationProcess =
          new RegistrationProcess.fromJson(_jsonString);
      return _registrationProcess;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<RegistrationProcess> UpdateAdminRegistrationProcess(
      process) async {
    final response = await updateAdminRegistrationProcess(process);
    // updateCookie(response);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _registrationProcess =
      new RegistrationProcess.fromJson(_jsonString);
      return _registrationProcess;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<VotingProcess> ReloadAdminVotingProcess(
      process) async {
    final response = await fetchVotingProcess(process);
    // updateCookie(response);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _votingProcess =
      new VotingProcess.fromJson(_jsonString);
      return _votingProcess;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<VotingProcess> UpdateAdminVotingProcess(
      process) async {
    final response = await updateAdminVotingProcess(process);
    // updateCookie(response);
    try {
      var _jsonString = json.decode(utf8.decode(response.bodyBytes));
      var _votingProcess =
      new VotingProcess.fromJson(_jsonString);
      return _votingProcess;
    } catch (e) {
      throw Exception(e);
    }
  }

}
