import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();

  bool _isEmailTaken = false;
  bool _isEmailValid = true;
  bool _isUsernameTaken = false;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;
  bool _isDeviceInfoLoaded = false;
  bool _isCheckingEmail = false;
  bool _isCheckingUsername = false;

  Map<String, dynamic> _deviceInfo = {};

  final PageController _pageController = PageController();

  final RegExp _emailRegExp =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        _checkUsernameExists(_usernameController.text);
      }
    });
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData;

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData = {
        'device_id': iosInfo.identifierForVendor,
        'device_model': iosInfo.utsname.machine,
        'os_version': iosInfo.systemVersion,
      };
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData = {
        'device_id': androidInfo.id,
        'device_model': androidInfo.model,
        'os_version': androidInfo.version.release,
      };
    } else {
      deviceData = {
        'device_id': 'unknown',
        'device_model': 'unknown',
        'os_version': 'unknown',
      };
    }

    setState(() {
      _deviceInfo = deviceData;
      _isDeviceInfoLoaded = true;
    });
  }

  Future<void> _validateEmailAndCheckExists(String email) async {
    setState(() {
      _isCheckingEmail = true;
      _isEmailValid = _emailRegExp.hasMatch(email);
      _isEmailTaken = false;
    });

    if (_isEmailValid) {
      bool emailExists = await _doesEmailExist(email);
      setState(() {
        _isEmailTaken = emailExists;
      });
    }

    setState(() {
      _isCheckingEmail = false;
    });
  }

  Future<void> _checkUsernameExists(String username) async {
    setState(() {
      _isCheckingUsername = true;
      _isUsernameTaken = false;
    });

    if (username.isNotEmpty) {
      bool usernameExists = await _doesUsernameExist(username);
      setState(() {
        _isUsernameTaken = usernameExists;
      });
    }

    setState(() {
      _isCheckingUsername = false;
    });
  }

  Future<bool> _doesEmailExist(String email) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> _doesUsernameExist(String username) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  void _validatePassword() {
    setState(() {
      _isPasswordValid = _passwordController.text.isNotEmpty;
      _isConfirmPasswordValid =
          _confirmPasswordController.text == _passwordController.text;
    });
  }

  void _nextPage() {
    if (_pageController.page == 0) {
      _validateEmailAndCheckExists(_emailController.text).then((_) {
        if (_isEmailValid && !_isEmailTaken) {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      });
    } else if (_pageController.page == 1) {
      _checkUsernameExists(_usernameController.text).then((_) {
        if (!_isUsernameTaken && _usernameController.text.isNotEmpty) {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      });
    } else if (_pageController.page == 2) {
      _validatePassword();
      if (_isPasswordValid && _isConfirmPasswordValid) {
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
  }

  Future<void> _registerUser() async {
    // Combine all the data collected from the form
    Map<String, dynamic> userData = {
      'email': _emailController.text,
      'username': _usernameController.text,
      'password': _passwordController.text, // Consider hashing in a real app
      'device_info': _deviceInfo,
    };

    // Add the data to Firestore
    await FirebaseFirestore.instance.collection('users').add(userData);

    // Show confirmation or navigate to the next screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("User registered successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Optionally navigate to another screen here
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff10111B),
      body: PageView(
        controller: _pageController,
        physics:
            NeverScrollableScrollPhysics(), // Disable swipe to change pages
        children: <Widget>[
          _buildEmailStep(),
          _buildUsernameStep(),
          _buildPasswordStep(),
          _buildFinalStep(),
        ],
      ),
    );
  }

  Widget _buildEmailStep() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Enter your email',
              errorText: !_isEmailValid
                  ? "Invalid email format"
                  : _isEmailTaken
                      ? "Email is already registered"
                      : null,
            ),
            onChanged: (value) {
              setState(() {
                _isEmailValid = true; // Reset the validation state
                _isEmailTaken = false; // Reset the duplicate check state
              });
            },
            onSubmitted: (value) =>
                _validateEmailAndCheckExists(value), // Validate on submit
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (_isEmailValid && !_isEmailTaken && !_isCheckingEmail)
                ? _nextPage
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameStep() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            decoration: InputDecoration(
              labelText: 'Enter your username',
              errorText: _isUsernameTaken ? "Username is already taken" : null,
            ),
            onChanged: (value) {
              setState(() {
                _isUsernameTaken = false; // Reset the duplicate check state
              });
            },
            onSubmitted: (value) =>
                _checkUsernameExists(value), // Validate on submit
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (!_isUsernameTaken &&
                    !_isCheckingUsername &&
                    _usernameController.text.isNotEmpty)
                ? _nextPage
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Enter your password',
              errorText: !_isPasswordValid ? "Password cannot be empty" : null,
            ),
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _isPasswordValid = true; // Reset the validation state
              });
            },
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm your password',
              errorText:
                  !_isConfirmPasswordValid ? "Passwords do not match" : null,
            ),
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _isConfirmPasswordValid = true; // Reset the validation state
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (_isPasswordValid && _isConfirmPasswordValid)
                ? _nextPage
                : null,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalStep() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _isDeviceInfoLoaded
              ? Text("All set!")
              : CircularProgressIndicator(), // Show loading if device info is not ready
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isDeviceInfoLoaded
                ? () {
                    _registerUser(); // Add the user data to Firebase when continue is clicked
                  }
                : null,
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}
