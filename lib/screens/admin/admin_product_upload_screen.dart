import 'dart:io';

import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/screens/admin/admin_home_screen.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class AdminUploadScreen extends StatefulWidget {
  static const routeName = '/admin-product-upload';

  @override
  _AdminUploadScreenState createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _infoController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _productId = Uuid().v4();
  bool _isUploading = false;
  File _file;

  /* **************************************************************** */

  compressImage() async {
    final _tempDir = await getTemporaryDirectory();
    final _path = _tempDir.path;
    Im.Image _imageFile = Im.decodeImage(_file.readAsBytesSync());
    final _compressedImageFile = File('$_path/img_$_productId.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(
          _imageFile,
          quality: 85,
        ),
      );

    setState(() {
      _file = _compressedImageFile;
    });
  }

  uploadImage(imageFile) async {
    TaskSnapshot storageSnap =
        await storageRef.child('product_$_productId.jpg').putFile(imageFile);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleSubmit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isUploading = true;
    });

    await compressImage();

    String _mediaUrl = await uploadImage(_file);

    Provider.of<Products>(context, listen: false).createPostInFirestore(
      productId: _productId,
      mediaUrl: _mediaUrl,
      title: _titleController.text.trim(),
      price: _priceController.text.trim(),
      info: _infoController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    setState(() {
      _file = null;
      _isUploading = false;
      _productId = Uuid().v4();
      _titleController.clear();
      _priceController.clear();
      _infoController.clear();
      _descriptionController.clear();
    });

    Navigator.of(context).pushReplacementNamed(AdminHomeScreen.routeName);
  }

  /* **************************************************************** */

  clearFormInfo() {
    _file = null;
    _titleController.clear();
    _priceController.clear();
    _infoController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final _pickedFile = ModalRoute.of(context).settings.arguments as PickedFile;
    setState(() {
      _file = File(_pickedFile.path);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blueGrey,
          ),
          onPressed: () {
            clearFormInfo();
            Navigator.pop(context);
          },
        ),
        title: RichText(
          text: TextSpan(
            text: 'Add',
            style: GoogleFonts.galada(
              textStyle: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            children: [
              TextSpan(
                text: 'Product',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          FlatButton(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              'CREATE',
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: _isUploading ? null : handleSubmit,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          children: [
            _isUploading ? linearProgress() : Text(''),
            Container(
              height: 210.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_file),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            ListTile(
              leading: Icon(
                Icons.title,
                color: Theme.of(context).primaryColor,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Product Title',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.money,
                color: Theme.of(context).primaryColor,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: _priceController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Product Price',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: _infoController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Product Short Information',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.description,
                color: Theme.of(context).primaryColor,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Product Description',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
