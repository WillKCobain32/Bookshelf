import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/review.dart';
import '../../viewsmodel/auth_viewmodel.dart';
import '../../viewsmodel/review_form_ciewmodel.dart';
import '../../widgets/star_rating.dart';

class ReviewFormPage extends StatefulWidget {
  final String bookId;
  final Review? existingReview;

  const ReviewFormPage({super.key, required this.bookId, this.existingReview});

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _textController.text = widget.existingReview!.text;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ReviewFormViewModel>().loadExisting(widget.existingReview!);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(ReviewFormViewModel vm) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: vm.date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) vm.setDate(picked);
  }

  Future<void> _submit(ReviewFormViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    final userId = context.read<AuthViewModel>().currentUser?.id ?? '';
    final success = await vm.submit(
      existingId: widget.existingReview?.id,
      bookId: widget.bookId,
      userId: userId,
      text: _textController.text,
    );
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else if (vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReviewFormViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReview == null ? 'Nova avaliacao' : 'Editar avaliacao'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Sua nota', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Center(
                  child: StarRating(rating: vm.rating, size: 40, onChanged: vm.setRating),
                ),
                if (vm.rating <= 0)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Toque em uma estrela para avaliar',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _textController,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    labelText: 'Resenha (opcional)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != null && value.length > 500) {
                      return 'A resenha deve ter no maximo 500 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data da leitura'),
                  subtitle: Text(
                      '${vm.date.day.toString().padLeft(2, '0')}/${vm.date.month.toString().padLeft(2, '0')}/${vm.date.year}'),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () => _pickDate(vm),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Ja tinha lido antes (releitura)'),
                  value: vm.relido,
                  onChanged: vm.setRelido,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Contem spoilers'),
                  value: vm.contemSpoiler,
                  onChanged: vm.setContemSpoiler,
                ),
                const SizedBox(height: 16),
                if (vm.errorMessage != null) ...[
                  Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                ],
                ElevatedButton(
                  onPressed: vm.isSaving ? null : () => _submit(vm),
                  child: vm.isSaving
                      ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Salvar avaliacao'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

