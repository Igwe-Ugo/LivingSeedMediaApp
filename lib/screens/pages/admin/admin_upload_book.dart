import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../common/widget.dart';

class UploadBookScreen extends StatefulWidget {
  const UploadBookScreen({super.key});

  @override
  State<UploadBookScreen> createState() => _UploadBookScreenState();
}

class _UploadBookScreenState extends State<UploadBookScreen> {
  int numOfContents = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _audienceController = TextEditingController();
  final TextEditingController _aboutAuthor = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _bookChapterController = TextEditingController();

  XFile? _coverImage;
  PlatformFile? _bookFile;

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _coverImage = pickedImage;
      });
    }
  }

  Future<void> _pickBookFile() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _bookFile = result.files.first;
      });
    }
  }

  void _uploadBook() {
    if (_formKey.currentState!.validate() &&
        _coverImage != null &&
        _bookFile != null) {
      // Perform the upload logic here, e.g., send data to backend or Firebase
      showMessage('Book uploaded successfully!', context);
      // Clear the form
      _formKey.currentState!.reset();
      setState(() {
        _coverImage = null;
        _bookFile = null;
      });
    } else {
      showMessage('Please fill all fields and upload files!', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        icon: const Icon(
                          Iconsax.arrow_left_2,
                          size: 17,
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Upload Book',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: WidgetStatePropertyAll(0),
                      ),
                      onPressed: _pickCoverImage,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: const [
                            Icon(
                              Iconsax.image,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              'Upload Cover Image',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_coverImage != null)
                      Text(
                        'Image Selected',
                        style: TextStyle(color: Colors.green[700]),
                      )
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Book Title...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the book title';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _subtitleController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Write the subtitle of book (optional)...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Author of book...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the author of the book';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Book Price... (#)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the prize of the book';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _bookChapterController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'How many chapters of book?...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of chapters of the book';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Write preface...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    maxLines: 10,
                    maxLength: 300,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write about the preface of the book';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "What's it about...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    maxLines: 10,
                    maxLength: 300,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe what the book is about!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _audienceController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Who's it about...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    maxLines: 10,
                    maxLength: 300,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the target audience';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).disabledColor.withOpacity(0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _aboutAuthor,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "About the author...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                    maxLines: 10,
                    maxLength: 300,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please tell us about the author';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(elevation: WidgetStatePropertyAll(0)),
                      onPressed: _pickBookFile,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: const [
                            Icon(
                              Iconsax.document_1,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Upload Book File (PDF)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_bookFile != null)
                      Text(
                        'File Selected',
                        style: TextStyle(color: Colors.green[700]),
                      )
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _uploadBook,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(10, 50),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Center(
                          child: Text('Upload Book',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17.0,
                                  color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
