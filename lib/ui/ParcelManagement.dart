import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:society_gatekeeper/bloc/PacelMangementBloc.dart';
import 'package:society_gatekeeper/models/FlatsModel.dart';
import 'package:society_gatekeeper/provider/ApiProvider.dart';

class ParcelManagement extends StatefulWidget {
  @override
  _ParcelManagementState createState() => _ParcelManagementState();
}

class _ParcelManagementState extends State<ParcelManagement> {
  final FocusNode dateFocusNode = FocusNode();
  final FocusNode nodeTodayButton = FocusNode();
  final FocusNode nodeflatDropdownValue = FocusNode();
  final FocusNode nodeSubmitButton = FocusNode();
  final FocusNode nodeUserName = FocusNode();

  final FocusNode nodeDeliveryAgencyNameController = FocusNode();

  final FocusNode nodeDeliveryAgencyContactNumber = FocusNode();
  var flatDropdownValue;
  List<String> flats;
  FlatsModel flatsModel;
  TextEditingController dateController = TextEditingController();
  TextEditingController deliveryAgencyNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  TextEditingController deliveryAgencyContactNumberController =
      TextEditingController();
  final _submitDetailsKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      img = image;
    });
  }

  // Future getImageFromGallery() async {
  //   ImagePicker imagePicker = ImagePicker();

  //   var image = await imagePicker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     img = image;
  //   });
  // }

  DateTime d;
  var isLoading;
  var img;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getFlats();
    flats = [];
  }

  getFlats() async {
    flatsModel = await parcelManagementBloc.getFlats();
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
                text: "Enter  Parcel Details",
              ),
              Tab(
                icon: Icon(Icons.directions_transit),
                text: "Show Details",
              ),
            ],
          ),
          title: Text('Parcel Management', style: TextStyle(fontSize: 20.0)),
        ),
        body: TabBarView(
          children: [
            //Parcel Details
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
                                                Colors.black.withOpacity(1.0)),
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
                                                  onChanged:
                                                      (String newValue) async {
                                                    var users = json.decode(
                                                        await storage.read(
                                                            key: 'users'));
                                                    setState(() {
                                                      for (var i in users) {
                                                        print(i);
                                                        if (i['flat_no'] ==
                                                            flatDropdownValue) {
                                                              print('object');
                                                          parcelManagementBloc
                                                              .userName
                                                              .value = i['_id'].toString();
                                                              print(i['_id']);
                                                        }
                                                      }
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
                                                      parcelManagementBloc
                                                          .getDeiveyAgencyName,
                                                  focusNode:
                                                      nodeDeliveryAgencyNameController,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please Enter Delivery Agency Name';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      deliveryAgencyNameController,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Delivery Agency Name",
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
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    WhitelistingTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        10)
                                                  ],
                                                  onChanged: parcelManagementBloc
                                                      .getDeliveyAgentContact,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please Enter Contact Number';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      deliveryAgencyContactNumberController,
                                                  focusNode:
                                                      nodeDeliveryAgencyContactNumber,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Delivery Agent Contact",
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
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            child: img == null
                                                ? Center(
                                                    child: Icon(Icons.queue),
                                                  )
                                                : Image.file(
                                                    img,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        Center(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                side: BorderSide(
                                                    color: Colors.black)),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    15.0)),
                                                  ),
                                                  builder: (context) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        // ListTile(
                                                        //   leading: Icon(Icons
                                                        //       .collections),
                                                        //   title: Text(
                                                        //       'Choose From Gallery'),
                                                        //   onTap: () {
                                                        //     getImageFromGallery();
                                                        //     Navigator.pop(
                                                        //         context);
                                                        //   },
                                                        // ),
                                                        ListTile(
                                                          leading: Icon(
                                                              Icons.camera_alt),
                                                          title: Text(
                                                              'Take A Photo'),
                                                          onTap: () {
                                                            getImageFromCamera();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Text(
                                              "Pick Image",
                                              style: TextStyle(fontSize: 20.0),
                                            ),
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
                                                  parcelManagementBloc
                                                          .flatNumber.value =
                                                      flatDropdownValue;
                                                  parcelManagementBloc.image.value = img;
                                                  parcelManagementBloc
                                                      .addParcelDetails();
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
                                  d = await parcelManagementBloc
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
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side:
                                              BorderSide(color: Colors.black)),
                                    ));
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
