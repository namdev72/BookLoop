import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/models/book_model.dart';
import '../../core/models/user_model.dart';
import '../../providers/book_provider.dart';

class AddBookModal extends StatefulWidget {
  final UserModel user;
  const AddBookModal({super.key, required this.user});

  @override
  State<AddBookModal> createState() => _AddBookModalState();
}

class _AddBookModalState extends State<AddBookModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _genreCtrl = TextEditingController();

  BookCategory _category = BookCategory.generic;
  BookCondition _condition = BookCondition.good;
  File? _imageFile;
  bool _uploading = false;

  static const _academicSubjects = [
    'Embedded Systems',
    'Software Engineering',
    'Microprocessors',
    'Cryptography',
    'Other',
  ];

  static const _genericGenres = [
    'Fiction',
    'Science',
    'History',
    'Self Help',
    'Fantasy',
    'Mystery',
    'Business',
    'Biography',
    'Travel',
    'Arts',
    'Other',
  ];

  String _selectedGenre = 'Fiction';

  @override
  void initState() {
    super.initState();
    _selectedGenre = _genericGenres.first;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _priceCtrl.dispose();
    _genreCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _uploading = true);

    final bookProvider = context.read<BookProvider>();
    final book = BookModel(
      id: '',
      title: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      condition: _condition,
      tokenPrice: int.tryParse(_priceCtrl.text) ?? 1,
      category: _category,
      genre: _selectedGenre,
      coverUrl: '',
      ownerId: widget.user.uid,
      ownerName: widget.user.name,
      createdAt: DateTime.now(),
    );

    final success = await bookProvider.addBook(
      book: book,
      imageFile: _imageFile,
    );

    setState(() => _uploading = false);
    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.accepted,
            content: Text(
              '🎉 Book listed successfully!',
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.92;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  24, 8, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 24),
                    _buildImagePicker(),
                    const SizedBox(height: 24),
                    _buildCategoryToggle(),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _titleCtrl,
                      label: 'Book Title',
                      hint: 'e.g. Clean Code',
                      icon: Icons.title_rounded,
                      validator: (v) =>
                          v!.isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _authorCtrl,
                      label: 'Author',
                      hint: 'e.g. Robert C. Martin',
                      icon: Icons.person_outline,
                      validator: (v) =>
                          v!.isEmpty ? 'Please enter an author' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildGenreDropdown(),
                    const SizedBox(height: 16),
                    _buildConditionDropdown(),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _priceCtrl,
                      label: 'Token Price 🪙',
                      hint: 'e.g. 3',
                      icon: Icons.monetization_on_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v!.isEmpty) return 'Enter token price';
                        if (int.tryParse(v) == null || int.parse(v) < 1) {
                          return 'Must be at least 1';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textMuted.withOpacity(0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text('List a Book', style: AppTextStyles.headlineLarge),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _imageFile != null
                ? AppColors.gold.withOpacity(0.5)
                : AppColors.glassBorder,
            width: _imageFile != null ? 2 : 1,
          ),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(_imageFile!, fit: BoxFit.cover),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Change',
                            style: AppTextStyles.labelSmall
                                .copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate_outlined,
                      color: AppColors.gold, size: 36),
                  const SizedBox(height: 8),
                  Text('Tap to add cover image',
                      style: AppTextStyles.bodyMedium),
                  Text('Optional — JPG, PNG',
                      style: AppTextStyles.labelSmall),
                ],
              ),
      ),
    );
  }

  Widget _buildCategoryToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.labelLarge),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _CategoryButton(
                label: '🎓 Academic',
                isSelected: _category == BookCategory.academic,
                onTap: () {
                  setState(() {
                    _category = BookCategory.academic;
                    _selectedGenre = _academicSubjects.first;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _CategoryButton(
                label: '📚 Generic',
                isSelected: _category == BookCategory.generic,
                onTap: () {
                  setState(() {
                    _category = BookCategory.generic;
                    _selectedGenre = _genericGenres.first;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenreDropdown() {
    final items = _category == BookCategory.academic
        ? _academicSubjects
        : _genericGenres;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _category == BookCategory.academic ? 'Subject' : 'Genre',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedGenre,
          dropdownColor: AppColors.cardLight,
          style: AppTextStyles.bodyLarge,
          decoration: _dropdownDecoration(
            icon: _category == BookCategory.academic
                ? Icons.school_rounded
                : Icons.category_rounded,
          ),
          items: items
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _selectedGenre = v!),
        ),
      ],
    );
  }

  Widget _buildConditionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Condition', style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        DropdownButtonFormField<BookCondition>(
          value: _condition,
          dropdownColor: AppColors.cardLight,
          style: AppTextStyles.bodyLarge,
          decoration: _dropdownDecoration(icon: Icons.star_outline_rounded),
          items: BookCondition.values.map((c) {
            final book = BookModel(
              id: '',
              title: '',
              author: '',
              condition: c,
              tokenPrice: 0,
              category: BookCategory.generic,
              genre: '',
              coverUrl: '',
              ownerId: '',
              ownerName: '',
              createdAt: DateTime.now(),
            );
            return DropdownMenuItem(
              value: c,
              child: Text(book.conditionLabel),
            );
          }).toList(),
          onChanged: (v) => setState(() => _condition = v!),
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration({required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
      filled: true,
      fillColor: AppColors.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium,
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
            filled: true,
            fillColor: AppColors.cardDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.gold, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.rejected),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _uploading ? null : _submit,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: _uploading
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('Uploading...',
                          style: TextStyle(color: Colors.white)),
                    ],
                  )
                : Text(
                    '🚀 Publish Book',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: Colors.white, fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.goldGradient : null,
          color: isSelected ? null : AppColors.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.gold
                : AppColors.glassBorder,
            width: isSelected ? 0 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.titleMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
