import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

import 'DataUser.dart';

class MyPhoneNumber extends StatefulWidget {
  final DataUser user;
  MyPhoneNumber(this.user);

  @override
  _MyPhoneNumberState createState() => _MyPhoneNumberState();
}

class _MyPhoneNumberState extends State<MyPhoneNumber> {
  final TextEditingController _phoneNumberTextEditingController = TextEditingController();
  String bookId="";

  bool makeStream=false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        appBar: MyAppBar(),
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
          child: MyDrawer(),),
        body:  SingleChildScrollView(
          child: Column(
            children: [

              StreamBuilder<QuerySnapshot> (
                stream:  Firestore.instance
                    .collection("Books")
                    .where("uid",isEqualTo: BookStore.sharedPreferences.getString(BookStore.userUID))
                    .snapshots(),
                builder: (context,dataSnapShot){


                  print("stream first  before if statment .......................................");

                if(dataSnapShot.hasData)
                  {print("stream first if statment .......................................");
                  print(".................before............................$makeStream");

                  makeStream=true;
                  print("................after.............................$makeStream");

                  }
                  return SizedBox(
                    height: height * 0.0,
                  );
                },),
              if(makeStream==true)
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("Books")
                      .where("uid",
                      isEqualTo: BookStore.sharedPreferences.getString(
                          BookStore.userUID))
                      .snapshots(),
                  builder: (context, dataSnapShot) {
                    print(
                        ".................before1............................$makeStream");

                    print(
                        "stream second before  if statment .......................................");
                    if (!dataSnapShot.hasData) {
                      print(
                          "stream second  if statment .......................................");

                      return CircularProgressIndicator();
                    }
                    Book book = Book.fromJson(
                        dataSnapShot.data.documents[0].data);
                    bookId = book.bookId;
                    return SizedBox(
                      height: height * 0.09,
                    );
                  },
                ),

              // SizedBox(
              //   height: height * 0.09,
              // ),
              Row(
                children: [
                  SizedBox(width: width*0.05,),
                  Text("Your phoneNumber : ",style: TextStyle(fontSize: 20,color: Colors.black),),
                  SizedBox(width: width*0.02,),
                  Flexible(
                    child: Text(widget.user.phoneNumber,style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,

                    ),),
                  ),

                ],
              ),

              SizedBox(
                height: height * 0.04,
              ),
              CustomTextField(
                data: Icons.local_phone_outlined,
                hintText: "write your new phoneNumber:",
                specifer: 1,
                isObsecure: false,
                controller:_phoneNumberTextEditingController,
              ),
              SizedBox(
                height: height * 0.09,
              ),
              ElevatedButton(
                onPressed: () {
                  updateDataToFirebase();
                },
                style: OutlinedButton.styleFrom(
                  elevation: 9,
                  backgroundColor: Colors.lightBlueAccent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }


  // Widget functionChange(Book book,BuildContext context)
  // {
  //   return ElevatedButton(
  //     onPressed: () {
  //
  //       updateDataToFirebase();
  //       Firestore.instance
  //           .collection("Books")
  //           .document(book.bookId)
  //           .updateData({'phoneNumber': _phoneNumberTextEditingController.text})
  //           .then((value) => print("User Updated in fireStore"))
  //           .catchError(
  //               (error) {
  //             print("Failed to update user in firestore: $error");
  //             showDialog(
  //               context: context,
  //               builder: (c) {
  //                 return ErrorAlertDialog(
  //                   message: "Please write your phone ",
  //                 );
  //               },
  //             );
  //           });
  //
  //       },
  //     style: OutlinedButton.styleFrom(
  //       elevation: 9,
  //       backgroundColor: Colors.lightBlueAccent,
  //       padding: EdgeInsets.symmetric(
  //         horizontal: 15,
  //         vertical: 6,
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(25),
  //       ),
  //     ),
  //     child: Text(
  //       'Change',
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: 20,
  //       ),
  //     ),
  //   );
  // }

  updateDataToFirebase() async {

      if (_phoneNumberTextEditingController.text.isNotEmpty) {
        await Firestore.instance
            .collection("users")
            .document(
            BookStore.sharedPreferences.getString(BookStore.userUID))
            .updateData({'phoneNumber': _phoneNumberTextEditingController.text})
            .then((value) => print("User Updated in fireStore"))
            .catchError(
                (error) {
              print("Failed to update user in firestore: $error");
              showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(
                    message: "Please write your phone1 ",
                  );
                },
              );
            });
        await Firestore.instance
            .collection("Books")
            .document(bookId)
            .updateData({'phoneNumber': _phoneNumberTextEditingController.text})
            .then((value) => print("User Updated in fireStore"))
            .catchError(
                (error) {
              print("Failed to update user in firestore: $error");
              showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(
                    message: "Please write your phone 2 ",
                  );
                },
              );
            });


        Fluttertoast.showToast(
          msg: "it\'s Done",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          //timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _phoneNumberTextEditingController.clear();
      }

    else
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "fill one of them at least ",);
        },);


  }




}