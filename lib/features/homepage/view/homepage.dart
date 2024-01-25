import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rvaa_1/components/appbar.dart';
import 'package:rvaa_1/features/homepage/view/device_page.dart';
import 'package:rvaa_1/features/homepage/view/selection_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const routeName = '/homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.access_time,
      //         color: Colors.black87,
      //       ),
      //       // SvgPicture.asset('assets/svgs/activity.svg'),
      //       label: 'Activity',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.home,
      //         color: Colors.black87,
      //       ),
      //       // SvgPicture.asset('assets/svgs/home.svg'),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.person,
      //         color: Colors.black87,
      //       ),
      //       // SvgPicture.asset('assets/svgs/profile.svg'),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),

      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'OOPS!! No device found.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DevicePage(),
                  ),
                );
              },
              child: SizedBox(
                width: Get.width * 0.35,
                height: Get.height * 0.06,
                child: const Center(
                    child: Text(
                  'Add Device',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                )),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'or',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Don\'t have a device yet?',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DummySelection(),
                  ),
                );
              },
              child: SizedBox(
                width: Get.width * 0.35,
                height: Get.height * 0.06,
                child: const Center(
                    child: Text(
                  'Buy',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
