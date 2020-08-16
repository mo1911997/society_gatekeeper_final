import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:society_gatekeeper/provider/ApiProvider.dart';
import 'package:society_gatekeeper/repository/Repository.dart';
import 'package:society_gatekeeper/ui/VisitorManagement.dart';

class VisitorManagementBloc {
  Repository repository = Repository();
  final flatNumber = BehaviorSubject<String>();
  final residentName = BehaviorSubject<String>();
  final vehicleNumber = BehaviorSubject<String>();
  final noOfPersons = BehaviorSubject<String>();
  
  Function(String) get getFlatNumber => flatNumber.sink.add;
  Function(String) get getResidentName => residentName.sink.add;
  Function(String) get getVehicleNumber => vehicleNumber.sink.add;
  Function(String) get getNoOfPersons => noOfPersons.sink.add;
  dispose() {
    flatNumber.close();
    residentName.close();
    vehicleNumber.close();
    noOfPersons.close();
  }


  getVisitorDetails(){
    repository.addVisitorDetail(flatNumber.value, residentName.value, vehicleNumber.value, noOfPersons.value);
  }

  Future<DateTime> showDateTimePicker(BuildContext context2) async {
    DateTime d = await showDatePicker(
      context: context2,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    return d;
    // if (d != null && d != selectedDate) {
    //   // openDialog();
    //   setState(() {
    //     print(d);
    //     var finalDate = d.toLocal().toString().split(' ');
    //     sdo = finalDate[0];
    //     dateController.text = finalDate[0];
    //     // getOrders(finalDate[0]);
    //     // Navigator.pop(context);
    //   });
    // }
  }

  getFlats() async {
    ApiProvider apiProvider = new ApiProvider();
    return await apiProvider.getFlats();
  }
}

final visitorManagementBloc = VisitorManagementBloc();
