import 'package:workmanager/workmanager.dart';

const eightHourCheck = 'eightHourCheck';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case eightHourCheck:
        print('Checking to see if a bike has been checked out > 8 hours');
        break;
    }
  });
}
