import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/DialogBox/loadingDialog.dart';
import 'file:///D:/GradProject/lib/Book_Pdf/pdfFiles.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

class pdfUpload extends StatefulWidget {


  @override
  _pdfUploadState createState() => _pdfUploadState();
}

class _pdfUploadState extends State<pdfUpload> {
  final TextEditingController _nametextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    Size screenSize = MediaQuery.of(context).size;

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
              SizedBox(
                height: screenSize.height * 0.09,
              ),
              SizedBox(
                height: screenSize.height * 0.09,
              ),
              CustomTextField(
                data: Icons.drive_file_rename_outline,
                hintText: "write name of pdf:",
                specifer: 1,
                isObsecure: false,
                controller:_nametextEditingController,
              ),
              SizedBox(
                height: screenSize.height * 0.09,
              ),

              ElevatedButton(
                onPressed: () {
                    uploadPdfBook();

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
                  'upload pdf',
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


  uploadPdfBook() async {
  if(_nametextEditingController.text.isNotEmpty) {
    String pdfID = DateTime
        .now()
        .microsecondsSinceEpoch
        .toString();

    print("zero function....................................");


    File file = await FilePicker.getFile(type: FileType.custom);
    print("zero 1 function....................................");

    String fileName = "$pdfID";
    print("z\ero 2 function....................................");

    savePDF(file, fileName);
  }
  else
  {
    displayDialog("Please fill name of  pdf Book ..");
  }


  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }




  void savePDF(File file, String fileName) async {

    showDialog(context: context, builder: (c){
      return LoadingAlertDialog(message: "Uploading , Please Wait..",);
    });

    print("first function....................................");


    final  StorageReference storageReference =FirebaseStorage.instance.ref().child("PDFBooks");
    print("pdf file.. before...........................................................");
    StorageUploadTask uploadTask = storageReference.child("pdfBook_$fileName").putFile(file);
    print("pdf file....... after............................................");

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print("first after.......... url....................................");
    String url=await taskSnapshot.ref.getDownloadURL();

    documentFileUpload(url,fileName);

  }

  void documentFileUpload(String url,String name) {
    print("seconad function....................................");

    Firestore.instance.collection("BookPdf").document(name).setData({
      "urlPicture":
      'https://firebasestorage.googleapis.com/v0/b/gradproject-5d48e.appspot.com/o/items%2Fdigital-book-logo.jpg?alt=media&token=c61a033d-1b9b-4ece-8b93-aa51ca0c4ceb',
      "urlPdf":url,
      'publisher':BookStore.sharedPreferences.getString(BookStore.userName),
      "name":_nametextEditingController.text,
      "uid":BookStore.sharedPreferences.getString(BookStore.userUID),
    }).then((value) {print("book pdf uploaded................");});

    _nametextEditingController.clear();
    Navigator.pop(context);
    Route route = MaterialPageRoute(builder: (c)=> pdfFiles() );
    Navigator.pushReplacement(context, route);

  }





}