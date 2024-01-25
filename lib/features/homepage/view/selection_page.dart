import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DummySelection extends StatefulWidget {
  const DummySelection({Key? key}) : super(key: key);

  @override
  State<DummySelection> createState() => _DummySelectionState();
}

class _DummySelectionState extends State<DummySelection>
    with SingleTickerProviderStateMixin {
  List<DummyData> dummy = [];
  List<DummyData> filteredDummy = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  int selectedCount = 0;
  double buttonFillPercentage = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isButtonFilled = false;

  @override
  void initState() {
    super.initState();
    _initDummyData();
    _initAnimation();
  }

  void _initDummyData() {
    dummy = List.generate(
      100,
      (index) => DummyData(
        isSelected: false,
        selectionOrder: 0,
        dummyName: 'Dummy $index',
      ),
    );
    filteredDummy = List.from(dummy);
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void toggleDummySelection(DummyData dummyData) {
    setState(() {
      if (dummyData.isSelected) {
        dummyData.isSelected = false;
        selectedCount--;
        dummyData.selectionOrder = 0;
      } else {
        if (selectedCount >= 5) {
          showSnackbar(context, 'Please select a maximum of 5 dummies.');
          return;
        }

        dummyData.isSelected = true;
        selectedCount++;
        dummyData.selectionOrder = selectedCount;

        if (selectedCount > 5) {
          showSnackbar(context, 'Please select a maximum of 5 dummies.');
        }
      }

      buttonFillPercentage = selectedCount / 5;
      _animation = Tween<double>(
        begin: _animation.value,
        end: buttonFillPercentage,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
      _animationController.forward(from: 0);

      isButtonFilled = selectedCount > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Select Dummy',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 20),
                  // Text(
                  //   'Selected Dummy:',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: filteredDummy.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final dummyData = filteredDummy[index];
                              return GestureDetector(
                                onTap: () => toggleDummySelection(dummyData),
                                child: buildDummyDataItem(dummyData, size),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _animation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isButtonFilled
                                  ? Colors.grey
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedCount == 1) {
                          // updateSelectedLanguagesRequest();
                        } else {
                          showSnackbar(
                              context, 'Please select minimum 1 dummy.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: isButtonFilled ? Colors.black : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'DONE',
                            style: TextStyle(
                              color:
                                  isButtonFilled ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDummyDataItem(DummyData dummydata, Size size) {
    return Container(
      height: Get.height * 0.2,
      decoration: BoxDecoration(
        color: dummydata.isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: dummydata.isSelected ? Colors.white : Colors.black,
          width: 2,
        ),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          // SizedBox(
          //   height: Get.height * 0.015,
          // ),
          Center(
            child: Text(
              dummydata.dummyName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dummydata.isSelected ? Colors.white : Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          const Spacer(),
          // Container(
          //   height: Get.height * 0.08,
          //   decoration: BoxDecoration(
          //     color: dummydata.isSelected ? Colors.black : Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.black,
    ),
  );
}

class DummyData {
  bool isSelected;
  int selectionOrder;
  String dummyName;

  DummyData({
    this.isSelected = false,
    this.selectionOrder = 0,
    required this.dummyName,
  });
}
