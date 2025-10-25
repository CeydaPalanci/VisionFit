import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GlassesCard extends StatelessWidget {
  final String name;
  final String brand;
  final String frameShape;
  final String imageUrl;
  final String price;
  final String purchaseLink;

  const GlassesCard({
    Key? key,
    required this.name,
    required this.brand,
    required this.frameShape,
    required this.imageUrl,
    required this.price,
    required this.purchaseLink,
  }) : super(key: key);

  void _launchURL() async {
    if (await canLaunch(purchaseLink)) {
      await launch(purchaseLink);
    } else {
      throw 'Could not launch $purchaseLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 5),
                Text("Brand: $brand", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                SizedBox(height: 5),
                Text("Frame Shape: $frameShape", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                SizedBox(height: 5),
                Text(price, style: TextStyle(color: Colors.blue[800], fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _launchURL,
                  child: Text('Buy Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
