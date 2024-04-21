import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rvaa_1/components/appbar.dart';
import 'package:rvaa_1/features/screens/biometric_screen.dart';

class RecentsScreen extends StatefulWidget {
  const RecentsScreen({Key? key}) : super(key: key);

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_supportState)
              const Text(
                'Biometric is supported',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              )
            else
              const Text(
                'Biometric is not supported',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            const SizedBox(
              height: 30,
            ),
            const Hero(
              tag: "clock",
              child: Icon(
                Icons.access_time,
                size: 60,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Your recent activity will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 0.08,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _getAvailableBiometrics,
              child: const Text(
                "Get Available biometrics",
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text(
                "Authenticate",
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     MaterialPageRoute(
            //       builder: (context) => const BiometricScreen(),
            //     );
            //   },
            //   child: const Text(
            //     "Biometric",
            //   ),
            // ),
          ],
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
