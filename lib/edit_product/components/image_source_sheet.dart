import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ImageSourceSheet extends StatelessWidget {
  final ImagePicker picker = new ImagePicker();

  final Function(File) onImageSelected;


  ImageSourceSheet({this.onImageSelected});
  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid){
      return BottomSheet(
        onClosing: (){},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlatButton(
              onPressed: () async{
                final PickedFile pickedfile = await picker.getImage(source: ImageSource.camera);
                onImageSelected(File(pickedfile.path));
                },
              child: Text("Câmera"),
            ),
            Divider(
              color: Colors.grey,
              height: 20,
            ),
            FlatButton(
              onPressed: () async{
                final PickedFile pickedfile = await picker.getImage(source: ImageSource.gallery);
                onImageSelected(File(pickedfile.path));
              },
              child: Text("Galeria"),
            ),
          ],
        ),
      );
    } else {
      return CupertinoActionSheet(
        title: const Text("Selecionar foto para o item"),
        message: Text("Escolha a origem da foto"),
        cancelButton: CupertinoActionSheetAction(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: (){},
            child: const Text("Câmera"),
          ),
          CupertinoActionSheetAction(
            child: const Text("Câmera"),
            onPressed: () {},
          ),
        ],
      );
    }
    }

}