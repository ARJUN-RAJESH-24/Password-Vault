import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_vault_app/models/credential.dart';
import 'package:password_vault_app/providers/credential_provider.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:password_vault_app/utils/theme.dart';

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
  bool _isPasswordVisible = false;

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
        final newCredential = Credential(
          title: _titleController.text,
          username: _usernameController.text,
          encryptedPassword: _passwordController.text,
        );
        credentialProvider.addCredential(newCredential);
      } else {
        final updatedCredential = Credential(
          id: widget.credential!.id,
          title: _titleController.text,
          username: _usernameController.text,
          encryptedPassword: _passwordController.text,
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
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDark,
              Color(0xFF0F0F10),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'e.g., Google, Bank of America',
                  icon: Iconsax.document_text,
                  autofillHints: const [AutofillHints.url],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _usernameController,
                  label: 'Username or Email',
                  hint: 'e.g., user@example.com',
                  icon: Iconsax.user,
                  autofillHints: const [AutofillHints.username, AutofillHints.email],
                ),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveCredential,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Iterable<String>? autofillHints,
  }) {
    return TextFormField(
      controller: controller,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.textSecondary),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter a value' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Iconsax.key, color: AppTheme.textSecondary),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
            color: AppTheme.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter a password' : null,
    );
  }
}
