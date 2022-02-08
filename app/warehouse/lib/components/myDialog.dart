// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/LongButton.dart';

import 'package:warehouse/components/myInputText.dart';
import 'package:warehouse/helper/validation.dart';

class ConfirmDialog extends StatelessWidget {
  final Function acceptFunc;
  // final Function cancelFunc;
  final String nameOfItem;

  const ConfirmDialog({
    Key key,
    this.acceptFunc,
    // this.cancelFunc,
    this.nameOfItem,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Item?'),
      content: Text('Delete $nameOfItem in your list'),
      actions: [
        FlatButton(
          textColor: Color(0xFF6200EE),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),
        FlatButton(
          textColor: Color(0xFF6200EE),
          onPressed: acceptFunc,
          child: Text('ACCEPT'),
        ),
      ],
    );
  }
}

class EditInputProductDialog extends StatefulWidget {
  final Function editFunction;
  final Product inputProduct;
  final int index;

  const EditInputProductDialog({
    Key key,
    @required this.editFunction,
    @required this.inputProduct,
    @required this.index,
  }) : super(key: key);
  @override
  _EditInputProductStateDialog createState() => _EditInputProductStateDialog(
        editFunction: editFunction,
        inputProduct: inputProduct,
        index: index,
      );
}

class _EditInputProductStateDialog extends State<EditInputProductDialog> {
  final Function editFunction;
  final Product inputProduct;
  final int index;

  _EditInputProductStateDialog({
    this.index,
    this.editFunction,
    this.inputProduct,
  });
  final _formkey = GlobalKey<FormState>();
  String productId, productName;
  int quantity;
  double inputPrice;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    setState(() {
      // productId = inputProduct.pId;
      // productName = inputProduct.name;
      // quantity = inputProduct.quantity;
      // inputPrice = inputProduct.inputPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(50),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Edit'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: my_org,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 5,
                ),
                alignment: Alignment.centerLeft,
                height: 70,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: my_org),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Text(
                  'Product Id : $productId',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 5,
                ),
                alignment: Alignment.centerLeft,
                height: 70,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: my_org),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Text(
                  'Product Name : $productName',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyInputText(
                initialValue: quantity.toString(),
                keytype: TextInputType.number,
                label: 'Quantity',
                onChanged: (value) {
                  setState(() {
                    quantity = int.parse(value);
                  });
                },
                validator: (str) {
                  return Validation.inputStringValidate(str);
                },
              ),
              SizedBox(
                height: 20,
              ),
              MyInputText(
                initialValue: inputPrice.toString(),
                keytype: TextInputType.number,
                label: 'Input Price (60.2)',
                onChanged: (value) {
                  setState(() {
                    inputPrice = double.parse(value);
                  });
                },
                validator: (str) {
                  return Validation.inputStringValidate(str);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: size.width * 0.27,
                      child: LongButton(
                        onclick: () async {
                          if (_formkey.currentState.validate()) {
                            // await widget.editFunction(
                            //   InputProduct(
                            //     inputPrice: inputPrice,
                            //     name: productName,
                            //     pId: productId,
                            //     quantity: quantity,
                            //   ),
                            //   index,
                            // );
                            // Navigator.pop(context);
                          }
                        },
                        text: 'Edit',
                        toastText: 'Please Wait',
                      ),
                    ),
                    Container(
                      width: size.width * 0.27,
                      child: LongButton(
                        onclick: () {
                          Navigator.pop(context);
                        },
                        text: 'Cancel',
                        toastText: 'Please Wait',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
