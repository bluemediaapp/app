import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//const API_BASE = "http://localhost";
const API_BASE = "http://blue.farfrom.world";
var client;

Future<Map<String, dynamic>> request(String method, String path, {Map<String, String> headers = const {}, Map<String, dynamic> body = const {}}) async {
    if (client == null) {
        client = await http.Client();
    }
    var url = Uri.parse(API_BASE + path);
    var response;
    if (method == "GET") {
        response = await client.get(url, headers: headers);
    } else {
        throw "Invalid method";
    }

    if (response.statusCode != 200) {
        throw "Bad status code";
    }
    var data = jsonDecode(response.body);
    print(data);
    return data;

}

