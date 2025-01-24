// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loja_virtual/screens/tabs/home_tab.dart';

class CreateProducts extends StatefulWidget {
  const CreateProducts({super.key});

  @override
  State<CreateProducts> createState() => _CreateProductsState();
}

class _CreateProductsState extends State<CreateProducts> {
  String? category;
  List<String> seletedSize = [];
  List<String> images = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descritionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              "Escolha a categoria do produto",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.start,
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection("products").get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                } else {
                  final categories = snapshot.data!.docs
                      .map((cat) => {
                            "id": cat.id,
                            "title": cat.get("title").toString(),
                          })
                      .toList();
                  return SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                        dropdownColor: const Color.fromARGB(255, 211, 211, 215),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(10),
                        padding: const EdgeInsets.all(16),
                        elevation: 1,
                        style: const TextStyle(fontSize: 20),
                        value: category,
                        hint: const Text("Escolha uma categoria"),
                        items: categories.map((categoryItem) {
                          return DropdownMenuItem<String>(
                            value: categoryItem["id"],
                            child: Text(
                              categoryItem["title"]!,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            category = value;
                          });
                        }),
                  );
                }
                return Container();
              },
            ),
            Text(
              "Título",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 3,
            ),
            TextFormField(
              controller: titleController,
              validator: (text) {
                if (text!.isEmpty) {
                  return "Título vazio.";
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Título do produto",
                  errorStyle: const TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Descrição",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 3,
            ),
            TextFormField(
              controller: descritionController,
              validator: (text) {
                if (text!.isEmpty) {
                  return "Descrição vazia.";
                }
                return null;
              },
              maxLines: null,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Descrição do produto",
                  errorStyle: const TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Preço",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 3,
            ),
            TextFormField(
              controller: priceController,
              validator: (text) {
                if (text!.isEmpty) {
                  return "Preço vazio.";
                }
                return null;
              },
              maxLines: 5,
              minLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "20.50",
                  errorStyle: const TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Tamanhos",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 50,
              width: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.5,
                  ),
                  children: ["P", "M", "G", "GG", "XGG"].map<Widget>((size) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (seletedSize.contains(size)) {
                            seletedSize.remove(size);
                          } else {
                            seletedSize.add(size);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            width: seletedSize.contains(size) ? 5 : 3,
                            color: seletedSize.contains(size)
                                ? Theme.of(context).primaryColor
                                : Colors.black45,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          size,
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton(
                onPressed: () async {
                  final pickerImage = ImagePicker();
                  final XFile? mediaImage =
                      await pickerImage.pickImage(source: ImageSource.gallery);
                  if (mediaImage == null) return;

                  final cloudinary = Cloudinary.signedConfig(
                      apiKey: "856935523333271",
                      apiSecret: "_vgpEGgcpTjBqV5smuw1SOnh26U",
                      cloudName: "ddmfhxtmk");

                  try {
                    int value = 0;
                    int name = value++;
                    final publicId =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    final response = await cloudinary.upload(
                        file: mediaImage.path,
                        resourceType: CloudinaryResourceType.image,
                        fileName: name.toString(),
                        publicId: publicId,
                        folder: "items/$category");

                    if (response.isSuccessful) {
                      images.add(response.secureUrl!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Theme.of(context).primaryColor,
                            content:
                                const Text("Imagem adicionada com sucesso!")),
                      );
                    } else {
                      throw Exception(
                          "Erro ao fazer upload: ${response.error}");
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Theme.of(context).primaryColor,
                          content: Text("Erro ao fazer upload da image: $e!")),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Theme.of(context).primaryColor),
                ),
                child: const Text(
                  "Adicionar imagens",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
            const SizedBox(
              height: 12,
            ),
            images.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: const Color.fromARGB(255, 211, 211, 215),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                              images.map((urlImage) => urlImage).toString()),
                        ),
                      ],
                    ),
                  )
                : Container(),
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      images.isNotEmpty &&
                      category != null) {
                    await FirebaseFirestore.instance
                        .collection("products")
                        .doc(category)
                        .collection("items")
                        .add({
                      "title": titleController.text,
                      "description": descritionController.text,
                      "price": double.parse(priceController.text),
                      "size": seletedSize,
                      "images": images
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeTab(),
                    ));
                  } else if (category == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Escolha uma categoria!")),
                    );
                  } else if (images.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Adicione uma imagem!")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Preencha todos os campos!")),
                    );
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Theme.of(context).primaryColor)),
                child: const Text("Criar",
                    style: TextStyle(color: Colors.white, fontSize: 18)))
          ],
        ),
      ),
    );
  }
}
