// ignore_for_file: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:sqlite_app/models/product_model.dart';
import 'package:sqlite_app/server/db_service.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({Key? key, this.model, this.isEditMode = false})
      : super(key: key);
  final ProductModel? model;
  final bool isEditMode;

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  //*--->Bien
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late ProductModel model;
  List<dynamic> categories = [];
  late DBService dbService;

  @override
  void initState() {
    super.initState();
    dbService = DBService();
    model = ProductModel(categoryId: -1, productName: "");

    if (widget.isEditMode) {
      model = widget.model!;
    }

    categories.add({"id": 1, "name": "T-Shirts"});
    categories.add({"id": 2, "name": "Shirts"});
    categories.add({"id": 3, "name": "Jeans"});
    categories.add({"id": 4, "name": "Trousers"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? 'Edit Product' : 'Add Product'),
      ),
      body: Form(
        key: globalKey,
        child: _formUI(),
      ),
      bottomNavigationBar: SizedBox(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormHelper.submitButton(
              "Save",
              () {
                if (validateAndSave()) {
                  if (widget.isEditMode) {
                    dbService.updateProduct(model).then(
                      (value) {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          "SQFLITE",
                          "Data Modifed Sucesssfuly",
                          "OK",
                          () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  } else {
                    dbService.addProduct(model).then(
                      (value) {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          "SQFLITE",
                          "Data Added Sucesssfuly",
                          "OK",
                          () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                  // print(model.toJson());
                }
              },
              borderRadius: 10,
              borderColor: Colors.green,
              btnColor: Colors.green,
            ),
            FormHelper.submitButton("Cancel", () {}, borderRadius: 10),
          ],
        ),
      ),
    );
  }

  //*-->formUI
  _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "ProductName",
              "Product Name",
              "",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
                return null;
              },
              (onSaved) {
                model.productName = onSaved.toString().trim();
              },
              initialValue: model.productName,
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.text_fields),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: FormHelper.inputFieldWidgetWithLabel(
                    context,
                    "ProductPrice",
                    "Product Price",
                    "",
                    (onValidate) {
                      if (onValidate.isEmpty) {
                        return "* Required";
                      }
                      return null;
                    },
                    (onSaved) {
                      model.price = double.parse(onSaved.trim());
                    },
                    initialValue:
                        model.price != null ? model.price.toString() : "",
                    showPrefixIcon: true,
                    prefixIcon: const Icon(Icons.currency_bitcoin),
                    borderRadius: 10,
                    contentPadding: 15,
                    fontSize: 14,
                    labelFontSize: 14,
                    paddingLeft: 0,
                    paddingRight: 0,
                    prefixIconPaddingLeft: 10,
                    isNumeric: true,
                  ),
                ),
                Flexible(
                    child: FormHelper.dropDownWidgetWithLabel(
                  context,
                  "Product Category",
                  "--Select---",
                  model.categoryId,
                  categories,
                  (onChanged) {
                    model.categoryId = int.parse(onChanged);
                  },
                  (onValidate) {},
                  borderRadius: 10,
                  labelFontSize: 14,
                  paddingRight: 0,
                  paddingLeft: 0,
                  hintFontSize: 14,
                  prefixIcon: const Icon(Icons.category),
                  showPrefixIcon: true,
                  prefixIconPaddingLeft: 10,
                ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "ProductDesc",
              "Product Description",
              "",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
                return null;
              },
              (onSaved) {
                model.productDesc = onSaved.toString().trim();
              },
              initialValue: model.productDesc ?? "",
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
              isMultiline: true,
              multilineRows: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            _picPicker(
              model.productPic ?? "",
              (file) => {
                setState(
                  () {
                    model.productPic = file.path;
                  },
                )
              },
            )
          ],
        ),
      ),
    );
  }

  _picPicker(
    String fileName,
    Function onFilePicked,
  ) {
    Future<XFile?> _imageFile;
    ImagePicker _picker = ImagePicker();

    return Column(
      children: [
        fileName != ""
            ? Image.file(
                File(fileName),
                width: 300,
                height: 300,
              )
            : SizedBox(
                child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930",
                  width: 350,
                  height: 250,
                  fit: BoxFit.scaleDown,
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.image,
                  size: 35,
                ),
                onPressed: () {
                  _imageFile = _picker.pickImage(source: ImageSource.gallery);
                  _imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.camera,
                  size: 35,
                ),
                onPressed: () {
                  _imageFile = _picker.pickImage(source: ImageSource.camera);
                  _imageFile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
          ],
        )
      ],
    );
  }

//*--->Xác_thực_và_lưu
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
