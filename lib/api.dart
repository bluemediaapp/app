import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//const API_BASE = "http://localhost";
const API_BASE = "http://blue.farfrom.world/api";
var client;

Future<Map<String, dynamic>> request(String method, String path, {Map<String, String> headers = const {}, Map<String, dynamic> body = const {}}) async {
    var res = await rawRequest(method, path, headers:headers, body:body);
    return jsonDecode(res);
}
Future<String> rawRequest(String method, String path, {Map<String, String> headers = const {}, Map<String, dynamic> body = const {}}) async {
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
        throw response.body;
    }
    var body = response.body;
    print(body);
    return body;
}
