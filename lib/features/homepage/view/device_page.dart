import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rvaa_1/components/activity_widget.dart';
import 'package:rvaa_1/components/appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../controller/blynk_server.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  late Timer _timer;
  bool isIgnitionOn = false;
  BlynkValueUpdater updater = BlynkValueUpdater();
  Future<void> fetchUpdate() async {
    try {
      // Make GET request to fetch latest value
      var url = Uri.parse(
          'https://blr1.blynk.cloud/external/api/get?token=oDYu4NIUESikAdZ_s3kyUgCEKWsIe08N&pin=v1');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse response and update state
        var value = response.body;
        setState(() {
          isIgnitionOn = (value == '1'); // Assuming '1' represents ON state
        });
      } else {
        throw 'Failed to fetch update. Status code: ${response.statusCode}';
      }
    } catch (e) {
      print('Error fetching update: $e');
      // Handle error (e.g., show error message to user)
    }
  }

  List<User> userList = [
    User(
      name: 'Vinayak',
      phoneNumber: '+91 84259 98424',
      carName: 'Suzuki Celerio',
      carNumber: 'MH 46 AT 0001',
    ),
    User(
      name: 'Kuldeep',
      phoneNumber: '+91 84829 74719',
      carName: 'Honda Accord',
      carNumber: 'MH 46 AB 1234',
    ),
    User(
      name: 'Ananya',
      phoneNumber: '+91 77384 40579',
      carName: 'Toyota Camry',
      carNumber: 'MH 46 XY 5678',
    ),
    User(
      name: 'Aman',
      phoneNumber: '+91 99677 85923',
      carName: 'Ford Mustang',
      carNumber: 'MH 46 ZA 9876',
    ),
  ];

  User selectedUser = User(
    name: 'Vinayak',
    phoneNumber: '+91 84259 98424',
    carName: 'Suzuki Celerio',
    carNumber: 'MH 46 AT 0001',
  );

  void showUserList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: Get.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (User user in userList)
                    ListTile(
                      title: Text(
                        '${user.name}\'s Car',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedUser = user;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void launchPhoneDialScreen(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    // Start the timer to fetch updates every 5 seconds (adjust interval as needed)
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchUpdate();
    });
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
  }

// Cancel the timer in dispose method
  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the widget is disposed to avoid memory leaks
    _timer.cancel();
  }

  Future<void> _authenticateAndToggleIgnition() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate for biometric access",
        options: const AuthenticationOptions(
          stickyAuth: true,
          // biometricOnly: true,
        ),
      );

      if (authenticated) {
        // If authenticated, toggle ignition state
        setState(() {
          isIgnitionOn = !isIgnitionOn;
        });
        await updater.updateValue(isIgnitionOn);
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(
        backButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${selectedUser.name}\'s Car',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              Text.rich(
                TextSpan(
                  text: '${selectedUser.carNumber}  |  ',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(
                      text: selectedUser.carName,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showUserList(context);
                    },
                    child: Container(
                      height: Get.height * 0.04,
                      width: Get.width * 0.45,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Other Vehicles',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_outlined)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Container(
                    height: Get.height * 0.04,
                    width: Get.width * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        'online',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Hero(
                    tag: "clock",
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings_outlined,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            _authenticateAndToggleIgnition();

                            // setState(() {
                            //   isIgnitionOn = !isIgnitionOn;
                            // });
                            // await updater.updateValue(isIgnitionOn);
                          },
                          // onTap: () {
                          //   if(isIgnitionOn == false ){
                          //     setState(()  {
                          //       isIgnitionOn = !isIgnitionOn;
                          //       updatevalue();
                          //     });
                          //   }
                          //   else{
                          //     setState(()  {
                          //       isIgnitionOn = !isIgnitionOn;
                          //       reupdatevalue();
                          //       });
                          //   }
                          // },
                          child: Container(
                            height: 135,
                            width: 120,
                            decoration: BoxDecoration(
                              color: isIgnitionOn
                                  ? Colors.green.withOpacity(0.3)
                                  : null,
                              border: Border.all(
                                color: isIgnitionOn ? Colors.green : Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                isIgnitionOn ? 'Ignition On' : 'Ignition Off',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isIgnitionOn ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 135,
                          //width: 135,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.grey[300],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  // height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(
                                    // height: 85,
                                    'assets/images/location.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                const Text(
                                  'Location Activity',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.04,
                    ),
                    ActivityWidget(
                      onPressed: () {},
                      size: size,
                      activityName: 'Recent Activity',
                      activityIcon: const Icon(
                        Icons.history_outlined,
                        size: 35,
                      ),
                    ),
                    ActivityWidget(
                      onPressed: () {
                        launchPhoneDialScreen(selectedUser.phoneNumber);
                      },
                      size: size,
                      activityIcon: const Icon(
                        Icons.phone_outlined,
                        size: 35,
                      ),
                      activityName: 'Call Driver',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate for biometric access",
        options: const AuthenticationOptions(
          stickyAuth: true,
          // biometricOnly: true,
        ),
      );

      debugPrint("Authenticated: $authenticated");
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    debugPrint("List of available biometrics: $availableBiometrics");

    if (!mounted) {
      return;
    }
  }
}

class User {
  final String name;
  final String phoneNumber;
  final String carName;
  final String carNumber;

  User({
    required this.name,
    required this.phoneNumber,
    required this.carName,
    required this.carNumber,
  });
}

// updatevalue() async{
//   var url =  Uri.parse('https://blr1.blynk.cloud/external/api/update?token=oDYu4NIUESikAdZ_s3kyUgCEKWsIe08N&v1=1');
//   var res = await http.get(url);
//
//   if (res.statusCode == 200) {
//     print("value updated");
//   } else {
//     throw "Unable to retrieve posts.";
//   }
// }
//
// reupdatevalue() async{
//   var url =  Uri.parse('https://blr1.blynk.cloud/external/api/update?token=oDYu4NIUESikAdZ_s3kyUgCEKWsIe08N&v1=0');
//   var res = await http.get(url);
//
//   if (res.statusCode == 200) {
//     print("value updated");
//   } else {
//     throw "Unable to retrieve posts.";
//   }
// }
