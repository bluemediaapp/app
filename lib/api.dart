import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "dart:convert";

//const API_BASE = "http://localhost";
const API_BASE = "http://blue.farfrom.world/api";
//const API_BASE = "https://96505dcae3cd.ngrok.io/api";
var client;

Future<dynamic> request(String method, String path, {Map<String, String> headers = const {}, Map<String, dynamic> body = const {}, bool includeToken = true}) async {
    var res = await rawRequest(method, path, headers:headers, body:body, includeToken:includeToken);
    return jsonDecode(res.body);
}
Future<http.Response> rawRequest(String method, String path, {Map<String, String> headers = const {}, Map<String, dynamic> body = const {}, bool includeToken = true, bool ignoreStatus = false}) async {
    Map<String, String> _headers = new Map.from(headers);
    if (client == null) {
        client = await http.Client();
    }
    var url = Uri.parse(API_BASE + path);

    // Attach auth headers
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "";
    if (token != "" && includeToken) {
        _headers["token"] = token;
    }


    var response;
    if (method == "GET") {
        response = await client.get(url, headers: _headers);
    } else {
        throw "Invalid method";
    }

    if (response.statusCode != 200 && !ignoreStatus) {
        throw response.body;
    }
    return response;
}
