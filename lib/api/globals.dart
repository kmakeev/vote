library globals;

import 'dart:ui';
String base_ws = 'ws://192.168.101.148:8000/ws/count/';
// String base_ws = 'ws://localhost:8000/ws/count/';

// String base = 'localhost:8000';
String base = '192.168.101.148:8000';
String userEndpoint = '/api/user/';
String registrationballot = '/api/registrationballot/';
String voteballot = '/api/voteballot/';
String onlyMyRegistrationProcess = 'api/onlyformyregistrationprocess/';
String adminRegistrationProcess = 'api/adminregistrationprocess/';
String adminVotingProcess = 'api/adminvotingprocess/';
String onlyMyVotingProcess = 'api/onlyformyvotingprocess/';
String lastMeetingEndpoint = '/api/lastmeeting/';
String lastAdminMeetingEndpoint = '/api/lastadminmeeting/';

var IsReleaseMode = false;

Color backgroundColor = Color.fromRGBO(20, 30, 46, 1);

String keyByStart = 's';
int msInterval = 3000;
