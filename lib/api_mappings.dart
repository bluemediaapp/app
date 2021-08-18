import "package:bloo/api.dart" as api;


// Live API
Future<String> login(String username, String password) async {
    var response = await api.request("POST", "/live/login", headers: {"username": username, "password": password}, includeToken: false);
    return response["token"];
}

Future<String> register(String username, String password) async {
    var response = await api.request("POST", "/live/register", headers: {"username": username, "password": password}, includeToken: false);
    return response["token"];
}

Future<List<dynamic>> get_recommended(Iterable<int> ignore) async {
    var ignore_formatted = ignore.join(",");
    List<dynamic> response = await api.request("GET", "/live/recommended/", headers: {"ignore": ignore_formatted});
    return response;
}


// Cached
Future<Map<String, dynamic>> get_current_user() async {
    var response = await api.request("GET", "/cached/user/@me");
    return response;
}
Future<Map<String, dynamic>> getUser(int userId) async {
    var response = await api.request("GET", "/cached/user/${userId}", includeToken: false);
    return response;
}
