import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubscriptionForm extends StatefulWidget {
  const SubscriptionForm({super.key});

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _idVeknController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _decklistController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _surnameFocus = FocusNode();
  final FocusNode _idVeknFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _decklistFocus = FocusNode();

  int _subscriptionType = 0; // Default: not selected



  @override
  void dispose() {
    // Dispose controllers and focus nodes
    _nameController.dispose();
    _surnameController.dispose();
    _idVeknController.dispose();
    _emailController.dispose();
    _decklistController.dispose();

    _nameFocus.dispose();
    _surnameFocus.dispose();
    _idVeknFocus.dispose();
    _emailFocus.dispose();
    _decklistFocus.dispose();

    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "name": _nameController.text,
        "surname": _surnameController.text,
        "id_vekn": _idVeknController.text,
        "email": _emailController.text,
        "decklist": _decklistController.text,
        "subscription_type": _subscriptionType,
      };

      _sendDataToBackend(data);
    }
  }

  void _sendDataToBackend(Map<String, dynamic> data) async {
    const backendUrl = "https://vtesitaly.com/api/check_and_register.php";

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      final result = jsonDecode(response.body);

      if (result["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["message"]))
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${result["message"]}"))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection error: $e"))
      );
    }
  }

  void _cancelForm() {
    // Clear all fields and return to the previous screen
    _nameController.clear();
    _surnameController.clear();
    _idVeknController.clear();
    _emailController.clear();
    _decklistController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _nameController,
            focusNode: _nameFocus,
            decoration: const InputDecoration(labelText: 'Name *'),
            validator: (value) => value!.isEmpty ? 'Insert name' : null,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _surnameController,
            focusNode: _surnameFocus,
            decoration: const InputDecoration(labelText: 'Surname *'),
            validator: (value) => value!.isEmpty ? 'Insert surname' : null,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            controller: _idVeknController,
            focusNode: _idVeknFocus,
            decoration: const InputDecoration(labelText: 'VEKN ID *'),
            validator: (value) => value!.isEmpty ? 'Insert your VEKN ID' : null,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _emailController,
            focusNode: _emailFocus,
            decoration: const InputDecoration(labelText: 'Email *'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value!.isEmpty ? 'Insert a valid mail' : null,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _decklistController,
            focusNode: _decklistFocus,
            decoration: const InputDecoration(labelText: 'Decklist (optional, you can upload later)'),
            maxLines: 4,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus();
            }
          ),
          DropdownButtonFormField<int>(
            value: _subscriptionType,
            items: const [
              DropdownMenuItem(value: 0, child: Text("Select Subscription (all prices are lunch included) *")),
              DropdownMenuItem(value: 1, child: Text("Italian GP (Saturday), 60€")),
              DropdownMenuItem(value: 2, child: Text("Italian GP + Redemption Event (Saturday + Sunday), 95€")),
            ],
            onChanged: (value) {
              setState(() {
                _subscriptionType = value!;
              });
              FocusScope.of(context).unfocus();
            },
            decoration: const InputDecoration(
              labelText: "",
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
              value == 0 ? 'Please select a subscription type' : null,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                  ),
                  child: const Text("Register", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: OutlinedButton(
                  onPressed: _cancelForm,
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
