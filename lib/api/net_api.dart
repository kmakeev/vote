import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:voting_flutter/models/models.dart';
import 'package:voting_flutter/api/globals.dart' as globals;
import 'package:cookie_jar/cookie_jar.dart';

// import 'package:flutter/foundation.dart' as Foundation;

Future<http.Response> getUserInfo() async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base, globals.userEndpoint)
      : Uri.http(globals.base, globals.userEndpoint);

  final response = await http.get(
    uri,
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptCharsetHeader: 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

Future<http.Response> getLastMeeting() async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base, globals.lastMeetingEndpoint)
      : Uri.http(globals.base, globals.lastMeetingEndpoint);


  final response = await http.get(
    uri,
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptCharsetHeader: 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

Future<http.Response> getLastAdminMeeting() async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base, globals.lastAdminMeetingEndpoint)
      : Uri.http(globals.base, globals.lastAdminMeetingEndpoint);
  final cookieJar = CookieJar();

  final response = await http.get(
    uri,
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptCharsetHeader: 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

Future<http.Response> updateRegistration(RegistrationBallot ballot) async {
  // print('token - ${ballot.csrf_token}');
  var uri = globals.IsReleaseMode
      ? Uri.https(
          globals.base, globals.registrationballot + ballot.id.toString() + '/')
      : Uri.http(globals.base,
          globals.registrationballot + ballot.id.toString() + '/');

  final response = await http.put(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
      'X-Csrftoken' : ballot.csrf_token!,
    },
    body: jsonEncode(ballot.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

Future<http.Response> updateVote(VoteBallot ballot) async {
  // print('token - ${ballot.csrf_token}');
  var uri = globals.IsReleaseMode
      ? Uri.https(
          globals.base, globals.voteballot + ballot.id.toString() + '/')
      : Uri.http(globals.base,
          globals.voteballot + ballot.id.toString() + '/');
  // print(jsonEncode(ballot.toJson()));
  final response = await http.put(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
      'X-Csrftoken' : ballot.csrf_token!,
    },
    body: jsonEncode(ballot.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

Future<http.Response> fetchRegistration(RegistrationBallot ballot) async {
  var uri = globals.IsReleaseMode
      ? Uri.https(
          globals.base, globals.registrationballot + ballot.id.toString() + '/')
      : Uri.http(globals.base,
          globals.registrationballot + ballot.id.toString() + '/');

  final response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

Future<http.Response> fetchVote(VoteBallot ballot) async {
  var uri = globals.IsReleaseMode
      ? Uri.https(
          globals.base, globals.voteballot + ballot.id.toString() + '/')
      : Uri.http(globals.base,
          globals.voteballot + ballot.id.toString() + '/');

  final response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}
/*
//Пока для личного процесса
Future<http.Response> updateRegistrationProcess(OnlyMyRegistrationProcess process) async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base, globals.onlyMyRegistrationProcess + process.id.toString() + '/')
      : Uri.http(globals.base, globals.onlyMyRegistrationProcess + process.id.toString() + '/');

  final response = await http.put(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(process.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}
*/

Future<http.Response> updateAdminRegistrationProcess(
    RegistrationProcess process) async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base,
          globals.adminRegistrationProcess + process.id.toString() + '/')
      : Uri.http(globals.base,
          globals.adminRegistrationProcess + process.id.toString() + '/');

  final response = await http.put(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
      'X-Csrftoken' : process.csrf_token!,
    },
    body: jsonEncode(process.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

Future<http.Response> fetchMyRegistrationProcess(
    OnlyMyRegistrationProcess process) async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base,
          globals.onlyMyRegistrationProcess + process.id.toString() + '/')
      : Uri.http(globals.base,
          globals.onlyMyRegistrationProcess + process.id.toString() + '/');

  final response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

Future<http.Response> fetchRegistrationProcess(
    RegistrationProcess process) async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base,
          globals.adminRegistrationProcess + process.id.toString() + '/')
      : Uri.http(globals.base,
          globals.adminRegistrationProcess + process.id.toString() + '/');

  final response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}

Future<http.Response> fetchVotingProcess(
    VotingProcess process) async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base,
          globals.adminVotingProcess + process.id.toString() + '/')
      : Uri.http(globals.base,
          globals.adminVotingProcess + process.id.toString() + '/');

  final response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}


Future<http.Response> fetchMyVotingProcess(
    OnlyMyVotingProcess process) async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base,
          globals.onlyMyVotingProcess + process.id.toString() + '/')
      : Uri.http(globals.base,
          globals.onlyMyVotingProcess + process.id.toString() + '/');

  final response = await http.get(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}


Future<http.Response> updateAdminVotingProcess(
    VotingProcess process) async {
  var uri = globals.IsReleaseMode
      ? Uri.https(globals.base,
      globals.adminVotingProcess + process.id.toString() + '/')
      : Uri.http(globals.base,
      globals.adminVotingProcess + process.id.toString() + '/');

  final response = await http.put(
    uri,
    headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
      'X-Csrftoken' : process.csrf_token!,
    },
    body: jsonEncode(process.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    // print(json.decode(utf8.decode(response.bodyBytes)));
    throw Exception(json.decode(utf8.decode(response.bodyBytes)));
  }
}
