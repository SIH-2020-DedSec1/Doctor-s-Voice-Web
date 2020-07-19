import 'dart:convert' show base64, utf8;

import 'dart:convert' show json;

import 'package:http/http.dart' as http;



const String TWILIO_SMS_API_BASE_URL = 'https://api.twilio.com/2010-04-01';




String toAuthCredentials(String accountSid, String authToken) =>
    base64.encode(utf8.encode(accountSid + ':' + authToken));




class MyTwilio {
  final String _accountSid;
  final String _authToken;

  const MyTwilio(this._accountSid, this._authToken);

  Messages get messages => Messages(_accountSid, _authToken);
}



class Messages {
  final String _accountSid;
  final String _authToken;

  const Messages(this._accountSid, this._authToken);

  Future<Map> create(data) async {
    var client = http.Client();

    var url =
        '${TWILIO_SMS_API_BASE_URL}/Accounts/${_accountSid}/Messages.json';

    try {
      var response = await client.post(url, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + toAuthCredentials(_accountSid, _authToken)
      }, body: {
        'From': data['from'],
        'To': data['to'],
        'Body': data['body']
      });

      return (json.decode(response.body));
    } catch (e) {
      return ({'Runtime Error': e});
    } finally {
      client.close();
    }
  }
}


