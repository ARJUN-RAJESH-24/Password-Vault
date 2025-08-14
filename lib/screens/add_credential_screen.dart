import 'package:flutter/material.dart';
import 'package:password_vault_app/models/credential.dart';
import 'package:password_vault_app/providers/credential_provider.dart';
import 'package:provider/provider.dart';

class AddCredentialScreen extends StatefulWidget {
  final Credential? credential;

  const AddCredentialScreen({super.key, this.credential});

  @override
  _AddCredentialScreenState createState() => _AddCredentialScreenState();
}

class _AddCredentialScreenState extends State<AddCredentialScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.credential?.title ?? '');
    _usernameController = TextEditingController(text: widget.credential?.username ?? '');
    _passwordController = TextEditingController(text: widget.credential != null 
        ? Provider.of<CredentialProvider>(context, listen: false).decryptPassword(widget.credential!.encryptedPassword)
        : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveCredential() {
    if (_formKey.currentState!.validate()) {
      final credentialProvider = Provider.of<CredentialProvider>(context, listen: false);
      if (widget.credential == null) {
        // Add new credential
        final newCredential = Credential(
          title: _titleController.text,
          username: _usernameController.text,
          encryptedPassword: _passwordController.text, // Will be encrypted by the provider
        );
        credentialProvider.addCredential(newCredential);
      } else {
        // Update existing credential
        final updatedCredential = Credential(
          id: widget.credential!.id,
          title: _titleController.text,
          username: _usernameController.text,
          encryptedPassword: _passwordController.text, // Will be encrypted by the provider
        );
        credentialProvider.updateCredential(updatedCredential);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.credential == null ? 'Add Credential' : 'Edit Credential'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username or Email'),
                validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) => value!.isEmpty ? 'Please enter a password' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCredential,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}