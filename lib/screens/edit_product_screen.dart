import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "editproduct";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imgUrlcontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    desc: '',
    imgUrl: '',
  );
  var isInit = true;
  var isLoading = false;
  var _initValues = {
    'title': '',
    'desc': '',
    'price': '',
    'imgUrl': '',
  };

  @override
  void initState() {
    _imgUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product = Provider.of<Products>(context, listen: false)
            .filterProducts(productId);
        _editedProduct = product;
        _initValues = {
          'title': product.title,
          'desc': product.desc,
          'price': product.price.toString(),
          // 'imgUrl': product.imgUrl,
          'imgUrl': '',
        };
        _imgUrlcontroller.text = _editedProduct.imgUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgUrlcontroller.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      if (_imgUrlcontroller.text.isEmpty) return;
      if (!_imgUrlcontroller.text.startsWith('http') ||
          !_imgUrlcontroller.text.startsWith('https')) return;
      // if (!_imgUrlcontroller.text.endsWith('.jpg') ||
      //     !_imgUrlcontroller.text.endsWith('.jpeg') ||
      //     !_imgUrlcontroller.text.endsWith('.png')) return;
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Error Occurred"),
            content: Text("Something Went Wrong"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.length > 0)
                          return null;
                        else
                          return "Please Provide a Title";
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          title: value,
                          desc: _editedProduct.desc,
                          imgUrl: _editedProduct.imgUrl,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      initialValue: _initValues['price'],
                      validator: (value) {
                        if (value.isEmpty) return "Value can't be negative";
                        if (double.tryParse(value) == null)
                          return "Enter a valid Number";
                        if (double.parse(value) <= 0)
                          return "Price can't be Negative";
                        else
                          return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          title: _editedProduct.title,
                          desc: _editedProduct.desc,
                          imgUrl: _editedProduct.imgUrl,
                          price: double.parse(value),
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      initialValue: _initValues['desc'],
                      validator: (value) {
                        if (value.isEmpty)
                          return "Please enter a valid description";
                        if (value.length < 10)
                          return "Added Description is too short";
                        return null;
                      },
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          title: _editedProduct.title,
                          desc: value,
                          imgUrl: _editedProduct.imgUrl,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 10, right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imgUrlcontroller.text.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Text("Enter a URL"),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imgUrlcontroller.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValues['imgUrl'],
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imgUrlcontroller,
                            focusNode: _imgUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) return "Enter an Image Url";
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https'))
                                return "Enter a valid a Url";
                              // if (!value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpeg') &&
                              //     !value.endsWith('.png'))
                              //   return "Invalid Image URL";
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                                title: _editedProduct.title,
                                desc: _editedProduct.desc,
                                imgUrl: value,
                                price: _editedProduct.price,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
