import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subidha/custom/Notification.dart';
import 'package:subidha/custom/custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'main_screen.dart';

class RegisterPage extends StatefulWidget {
  static const String idScreen = "register";
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController;
  final TextEditingController _cpasswordController = TextEditingController();

  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Container buildTitle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      alignment: Alignment.bottomCenter,
    );
  }

  Padding buildText(String text, double fontSize, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(color: theme.primaryColorDark, fontSize: fontSize),
      ),
    );
  }

  Padding buildInputField(
      {String labelText,
        String hintText,
        bool isObscured,
        ThemeData theme,
        IconData icon,
        Function validation,
        TextEditingController controller,
        bool isNumberOnly}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          icon: new Icon(icon ?? Icons.person),
          hintStyle: TextStyle(color: theme.primaryColorDark),
        ),
        obscureText: isObscured,
        keyboardType: isNumberOnly ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumberOnly
            ? [
          WhitelistingTextInputFormatter.digitsOnly,
        ]
            : [],
        validator: validation,
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // Refer step 1
      firstDate: DateTime(1960),
      lastDate: DateTime(2002),
      initialDatePickerMode: DatePickerMode.year,

      helpText: 'Must be 18 years old',
    );
  }

  SizedBox buildRegisterBtn(ThemeData theme) {
    return SizedBox(
      width: 250.0,
      child: RaisedButton(
        onPressed: () {
          register();
        },
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        color: theme.buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Text('Register'),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _emailRegularExpression = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp phoneNumberRegExp =
  new RegExp(r"^(984|985|986|974|975|980|981|982|961|988|972|963)\d{7}$");
  final FirebaseAuth fbAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16.0, kToolbarHeight, 16.0, 16.0),
          children: <Widget>[
            Align(
              child: SizedBox(
                width: 320.0,
                child: Card(
                  color: theme.primaryColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildTitle(theme),
                      SizedBox(
                        height: 18.0,
                      ),
                      Text(
                        'REGISTER YOUR ACCOUNT',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      buildInputField(
                        labelText: 'Name',
                        controller: _nameController,
                        icon: Icons.account_circle,
                        hintText: 'Enter name',
                        isObscured: false,
                        theme: theme,
                        validation: (value) {
                          if (value.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                        isNumberOnly: false,
                      ),
                      buildInputField(
                        labelText: 'Email Address',
                        controller: _emailController,
                        icon: Icons.email,
                        hintText: 'Enter email',
                        isObscured: false,
                        theme: theme,
                        validation: (value) {
                          if (value.isEmpty) {
                            return 'Field is required';
                          } else if (!_emailRegularExpression.hasMatch(value)) {
                            print('email');
                            return 'Enter valid email';
                          }
                          return null;
                        },
                        isNumberOnly: false,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      buildInputField(
                        labelText: 'Password',
                        controller: _passwordController,
                        icon: Icons.vpn_key,
                        hintText: 'Enter password',
                        isObscured: true,
                        theme: theme,
                        validation: (value) {
                          if (value.isEmpty) {
                            return 'Field is required';
                          }
                          else if (value.length < 8) {
                            return '8 or More character';
                          }
                          return null;
                        },
                        isNumberOnly: false,
                      ),
                      buildInputField(
                        labelText: 'Confirm Password',
                        controller: _cpasswordController,
                        icon: Icons.vpn_key,
                        hintText: 'Enter Confirm password',
                        isObscured: true,
                        theme: theme,
                        validation: (value) {
                          if (value.isEmpty) {
                            return 'Field is required';
                          }
                          else if (value != _passwordController.text) {
                            return 'Enter same password';
                          }
                          return null;
                        },
                        isNumberOnly: false,
                      ),
                      TextButton(
                        child: Text(_image == null ? 'Click to choose image' : 'Click to change image'),
                        onPressed: () async {
                          final pickedFile = await picker.getImage(source: ImageSource.gallery);
                          setState(() {
                            _image = File(pickedFile.path);
                          });
                        },
                      ),
                      _image == null ? SizedBox.shrink() : CircleAvatar(
                        radius: 80.0,
                        backgroundImage: FileImage(_image),
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      buildRegisterBtn(theme),
                      SizedBox(
                        height: 18.0,
                      ),
                      Text(
                        'Already have Account',
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                      //buildRegisterBtn(theme),
                      RawMaterialButton(
                        child: Text('Login Here', style: TextStyle(color: Theme.of(context).accentColor,),),
                        onPressed: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ), (route) => false);                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  register() async {
    if (_formKey.currentState.validate()) {
      if(_image == null) {
        CustomNotification(
          title: 'Error',
          color: Colors.red,
          message: 'Select profile photo first.',
        ).show(context);
      }
      else {
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();
        try {
          var user = await fbAuth.createUserWithEmailAndPassword(
            email: email, password: password,);
          FirebaseStorage _storage = FirebaseStorage.instance;
          var reference = _storage.ref().child("images/" + user.user.uid + ".jpg");
          var uploadTask = await reference.putFile(_image);
          user.user.updateProfile(
            displayName: _nameController.value.text,
            photoURL: await uploadTask.ref.getDownloadURL(),
          );
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()));
          CustomNotification(
            title: 'Registration',
            message:
            'Successfully registered now you can sign in.',
            color: Colors.green,
          ).show(context);
          setState(() {
            _emailController.text = '';
            _passwordController.text = '';
            _nameController.text = '';
            _image = null;
            _passwordController = null;
            _cpasswordController.text = null;
          });
        } catch (e) {
          if (e.code == 'network-request-failed') {
            CustomNotification(
              title: 'Network Error',
              message:
              'No Network Connection. Check your connection and try again.',
              color: Theme
                  .of(context)
                  .errorColor,
            ).show(context);
          } else {
            CustomNotification(
              title: 'Registration Error',
              message: e.code.toString() + 'An error occurred!',
              color: Theme
                  .of(context)
                  .errorColor,
            ).show(context);
          }
        }
      }
    }
  }
}

