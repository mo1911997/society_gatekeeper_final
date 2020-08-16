import 'package:flutter/material.dart';
import 'package:society_gatekeeper/bloc/VisitorManagementBloc.dart';
import 'package:society_gatekeeper/models/FlatsModel.dart';
import 'package:society_gatekeeper/provider/ApiProvider.dart';

class VisitorManagement extends StatefulWidget {
  @override
  _VisitorManagementState createState() => _VisitorManagementState();
}

class _VisitorManagementState extends State<VisitorManagement> {
  final FocusNode dateFocusNode = FocusNode();
  final FocusNode nodeTodayButton = FocusNode();
  final FocusNode nodeflatDropdownValue = FocusNode();
  final FocusNode nodeUserName = FocusNode();
  final FocusNode nodeUserVehicleDetails = FocusNode();
  final FocusNode nodeSubmitButton = FocusNode();
  final FocusNode nodeNumberOfPersons = FocusNode();

  TextEditingController dateController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userVehicleDetails = TextEditingController();
  TextEditingController numberOfPersonsController = TextEditingController();

  final _submitDetailsKey = GlobalKey<FormState>();
  var flatDropdownValue;
  List<String> flats;
  List visitors = [];
  DateTime d;
  FlatsModel flatsModel;
  var isLoading;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flats = [];
    isLoading = true;
    getFlats();
  }
  getVisitors() async
  {
    ApiProvider apiProvider = ApiProvider();
    visitors = await apiProvider.getVisitorDetails();
  }
  getFlats() async {
    flatsModel = await visitorManagementBloc.getFlats();
    setState(() {
      isLoading = false;
    });
    print(flatsModel.data.runtimeType);
    for (var i in flatsModel.data) {
      flats.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue[400],
            centerTitle: true,
            elevation: 0.0,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  icon: Icon(Icons.directions_car),
                  text: "Enter Details",
                ),
                Tab(
                  icon: Icon(Icons.directions_transit),
                  text: "Show Details",
                ),
              ],
            ),
            title: Text('Visitor  Management',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
          body: TabBarView(children: [
            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue[400],
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            children: <Widget>[
                              Form(
                                key: _submitDetailsKey,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  child: Card(
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 10.0, 10.0),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Colors.blue.withOpacity(1.0)),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.60,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              ListTile(
                                                title: DropdownButton<String>(
                                                  focusNode:
                                                      nodeflatDropdownValue,
                                                  value: flatDropdownValue,
                                                  icon: Icon(
                                                    Icons.arrow_downward,
                                                    color: Colors.green,
                                                  ),
                                                  iconSize: 0.0,
                                                  elevation: 16,
                                                  hint: Text(
                                                    "Flat Number",
                                                    style: TextStyle(
                                                        fontFamily: 'Raleway',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue),
                                                  ),
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.blue,
                                                  ),
                                                  onChanged: (String newValue) {
                                                    setState(() {
                                                      flatDropdownValue =
                                                          newValue;
                                                    });
                                                  },
                                                  items: flats.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            color: Colors.blue,
                                                            fontFamily:
                                                                'Raleway',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              ListTile(
                                                title: TextFormField(
                                                  onChanged:
                                                      visitorManagementBloc
                                                          .getResidentName,
                                                  focusNode: nodeUserName,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please Enter Name';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      userNameController,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Resident/Tenant Name",
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blue))),
                                                ),
                                              ),
                                              ListTile(
                                                title: TextFormField(
                                                  onChanged:
                                                      visitorManagementBloc
                                                          .getVehicleNumber,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please Enter Vehicle Details';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      userVehicleDetails,
                                                  focusNode:
                                                      nodeUserVehicleDetails,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Vehicle Number",
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blue))),
                                                ),
                                              ),
                                              ListTile(
                                                title: TextFormField(
                                                  onChanged:
                                                      visitorManagementBloc
                                                          .getNoOfPersons,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please Enter Vehicle Details';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      numberOfPersonsController,
                                                  focusNode:
                                                      nodeNumberOfPersons,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Number Of Persons",
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blue))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              child: RaisedButton(
                                                focusNode: nodeSubmitButton,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(18.0),
                                                    side: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0)),
                                                color: Colors.white,
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  visitorManagementBloc
                                                          .flatNumber.value =
                                                      flatDropdownValue;
                                                  visitorManagementBloc
                                                      .getVisitorDetails();
                                                  // checkInternetConnection();
                                                  // if (_addFormKey.currentState.validate()) {
                                                  //   checkAddDetails();
                                                  // } else {}
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),

            //Show Details
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              width: 125.0,
                              child: TextField(
                                focusNode: dateFocusNode,
                                controller: dateController,
                                onTap: () async {
                                  d = await visitorManagementBloc
                                      .showDateTimePicker(context);
                                },
                                decoration: InputDecoration(
                                    hintText: "Select Date",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[400],
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue[400]))),
                              ),
                            ),
                            Container(
                              child: RaisedButton(
                                focusNode: nodeTodayButton,
                                color: Colors.blue[400],
                                child: Text(
                                  "Today",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  print(DateTime.now());
                                  dateController.text =
                                      DateTime.now().toString().split(' ')[0];
                                  // getOrders(
                                  //     DateTime.now().toString().split(' ')[0]);
                                },
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.blue,
                          thickness: 2.0,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.67,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side:
                                              BorderSide(color: Colors.black)),
                                      color: Colors.blue[400],
                                    ));
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}
