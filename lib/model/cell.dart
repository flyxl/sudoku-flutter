class Cell {
  int _size = 0;
  int value = 0;
  int input = 0;
  bool needInput = false;
  late Set<int> candidates;

  final int row; // cell在宫中的行索引
  final int column; // cell在宫中的列索引

  Cell({
    required this.row,
    required this.column,
    required int size,
  }) {
    this._size = size;
    candidates = Set.from(List.generate(size, (i) => i + 1));
  }

  bool isInputValid() {
    return input == value;
  }

  bool isEditable() {
    return input == 0;
  }

  void setInput(int input) {
    this.input = input;
    // 计算candidates
  }

  Cell clone() {
    var c = Cell(row: this.row, column: this.column, size: this._size);
    c.value = this.value;
    c.input = this.input;
    c.needInput = this.needInput;
    c.candidates = Set.from(this.candidates);
    return c;
  }

  // 将Cell对象转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'size': _size,
      'value': value,
      'input': input,
      'needInput': needInput,
      'candidates': candidates.toList(),
      'row': row,
      'column': column,
    };
  }

  // 从JSON数据创建Cell对象
  factory Cell.fromJson(Map<String, dynamic> json) {
    final cell = Cell(
      row: json['row'],
      column: json['column'],
      size: json['size'],
    );
    cell.value = json['value'];
    cell.input = json['input'];
    cell.needInput = json['needInput'];
    cell.candidates = Set.from(json['candidates'] as List);
    return cell;
  }
}
