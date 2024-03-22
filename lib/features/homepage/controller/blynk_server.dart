import 'package:http/http.dart' as http;

class BlynkValueUpdater {
  final String _serverAddress = 'https://blr1.blynk.cloud';
  final String _authToken = 'oDYu4NIUESikAdZ_s3kyUgCEKWsIe08N';

  Future<void> updateValue(bool value) async {
    var url = Uri.parse('$_serverAddress/external/api/update?token=$_authToken&v1=${value ? 1 : 0}');
    var res = await http.get(url);

    if (res.statusCode == 200) {
      print("Value updated");
    } else {
      throw "Unable to update value.";
    }
  }
}
