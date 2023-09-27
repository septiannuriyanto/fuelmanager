import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomCounter extends StatelessWidget {
  final int? count;
  final VoidCallback? onCount;
  final Function(int)? onCountChange;
  final Function(int)? onManualChange;
  CustomCounter(
      {this.count,
      this.onCount,
      required this.onCountChange,
      required this.onManualChange});

  final counter_con = TextEditingController();

  @override
  Widget build(BuildContext context) {
    counter_con.text = TextEditingController().text = count.toString();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey.shade500)),
      width: 40,
      height: 55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    if (count! > 0) {
                      onCountChange!(-1);
                    }
                    counter_con.text = count.toString();
                  },
                  icon: const Icon(Icons.remove_circle_outline)),
              SizedBox(
                width: 20,
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade500,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: counter_con,
                  onFieldSubmitted: (value) {
                    if (value.isEmpty) {
                      value = '0';
                    }
                    onManualChange!(int.parse(value));
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    onCountChange!(1);
                    counter_con.text = count.toString();
                  },
                  icon: const Icon(Icons.add_circle_outline))
            ],
          ),
        ],
      ),
    );
  }
}
