double valueConverter(double value, String origUnit, String destUnit) {
  return double.parse(
    valueConverterRaw(value, origUnit, destUnit).toStringAsFixed(3),
  );
}

double valueConverterRaw(double value, String origUnit, String destUnit) {
  switch (origUnit) {
    case "pc(s)":
      switch (destUnit) {
        case "pkg(s)":
          return 0.05 * value;
        case "btl(s)":
          return 0.05 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return 0;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return 0;
        case "cl":
          return 0;
        case "dl":
          return 0;
        case "l":
          return 0;
        case "dash":
          return 0;
        case "tsp":
          return 0;
        case "tbsp":
          return 0;
        case "fl oz":
          return 0;
        case "c":
          return 0;
        case "pt":
          return 0;
        case "qt":
          return 0;
        case "gal":
          return 0;
        default:
          return 0;
      }

    case "pkg(s)":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "btl(s)":
          return 1 * value;
        case "g":
          return value / 0.01;
        case "kg":
          return 1 * value;
        case "pinch":
          return value / 0.001;
        case "oz":
          return value / 0.01;
        case "lb":
          return value / 0.5;
        case "ml":
          return value / 0.001;
        case "cl":
          return value / 0.01;
        case "dl":
          return value / 0.1;
        case "l":
          return 1 * value;
        case "dash":
          return value / 0.001;
        case "tsp":
          return value / 0.01;
        case "tbsp":
          return value / 0.01;
        case "fl oz":
          return value / 0.03;
        case "c":
          return value / 0.025;
        case "pt":
          return value / 0.5;
        case "qt":
          return 1 * value;
        case "gal":
          return value / 4;
        default:
          return 0;
      }

    case "btl(s)":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 1 * value;
        case "g":
          return value / 0.01;
        case "kg":
          return 1 * value;
        case "pinch":
          return value / 0.001;
        case "oz":
          return value / 0.01;
        case "lb":
          return value / 0.5;
        case "ml":
          return value / 0.001;
        case "cl":
          return value / 0.01;
        case "dl":
          return value / 0.1;
        case "l":
          return 1 * value;
        case "dash":
          return value / 0.001;
        case "tsp":
          return value / 0.01;
        case "tbsp":
          return value / 0.01;
        case "fl oz":
          return value / 0.03;
        case "c":
          return value / 0.025;
        case "pt":
          return value / 0.5;
        case "qt":
          return 1 * value;
        case "gal":
          return value / 4;
        default:
          return 0;
      }

    case "g":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.001 * value;
        case "btl(s)":
          return 0.001 * value;
        case "kg":
          return 0.001 * value;
        case "pinch":
          return 2.667335 * value;
        case "oz":
          return 0.0352739619 * value;
        case "lb":
          return 0.00220462262 * value;
        case "ml":
          return 0;
        case "cl":
          return 0;
        case "dl":
          return 0;
        case "l":
          return 0;
        case "dash":
          return 0;
        case "tsp":
          return 0;
        case "tbsp":
          return 0;
        case "fl oz":
          return 0;
        case "c":
          return 0;
        case "pt":
          return 0;
        case "qt":
          return 0;
        case "gal":
          return 0;
        default:
          return 0;
      }

    case "kg":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 1 * value;
        case "btl(s)":
          return 1 * value;
        case "g":
          return 1000 * value;
        case "pinch":
          return 2667.334576 * value;
        case "oz":
          return 35.2739619 * value;
        case "lb":
          return 2.20462262 * value;
        case "ml":
          return 0;
        case "cl":
          return 0;
        case "dl":
          return 0;
        case "l":
          return 0;
        case "dash":
          return 0;
        case "tsp":
          return 0;
        case "tbsp":
          return 0;
        case "fl oz":
          return 0;
        case "c":
          return 0;
        case "pt":
          return 0;
        case "qt":
          return 0;
        case "gal":
          return 0;
        default:
          return 0;
      }

    case "pinch":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.001 * value;
        case "btl(s)":
          return 0.001 * value;
        case "g":
          return 0.374906 * value;
        case "kg":
          return 0.000374906 * value;
        case "oz":
          return 0.013224 * value;
        case "lb":
          return 0.0008265 * value;
        case "ml":
          return 0.3125 * value;
        case "cl":
          return 0.03125 * value;
        case "dl":
          return 0.003125 * value;
        case "l":
          return 0.0003125 * value;
        case "dash":
          return value / 2;
        case "tsp":
          return value / 16;
        case "tbsp":
          return value / 48;
        case "fl oz":
          return value / 96;
        case "c":
          return value / 768;
        case "pt":
          return value / 1536;
        case "qt":
          return value / 3072;
        case "gal":
          return value / 12288;
        default:
          return 0;
      }

    case "oz":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.01 * value;
        case "btl(s)":
          return 0.01 * value;
        case "g":
          return 28.3495231 * value;
        case "kg":
          return 0.0283495231 * value;
        case "pinch":
          return value / 0.013224;
        case "lb":
          return value * 0.0625;
        case "ml":
          return 0;
        case "cl":
          return 0;
        case "dl":
          return 0;
        case "l":
          return 0;
        case "dash":
          return 0;
        case "tsp":
          return 0;
        case "tbsp":
          return 0;
        case "fl oz":
          return 0;
        case "c":
          return 0;
        case "pt":
          return 0;
        case "qt":
          return 0;
        case "gal":
          return 0;
        default:
          return 0;
      }

    case "lb":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.5 * value;
        case "btl(s)":
          return 0.5 * value;
        case "g":
          return 453.59237 * value;
        case "kg":
          return 0.45359237 * value;
        case "pinch":
          return value / 0.0008265;
        case "oz":
          return value * 16;
        case "ml":
          return 0;
        case "cl":
          return 0;
        case "dl":
          return 0;
        case "l":
          return 0;
        case "dash":
          return 0;
        case "tsp":
          return 0;
        case "tbsp":
          return 0;
        case "fl oz":
          return 0;
        case "c":
          return 0;
        case "pt":
          return 0;
        case "qt":
          return 0;
        case "gal":
          return 0;
        default:
          return 0;
      }

    case "ml":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.001 * value;
        case "btl(s)":
          return 0.001 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value / 0.3125;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "cl":
          return 0.1 * value;
        case "dl":
          return 0.01 * value;
        case "l":
          return 0.001 * value;
        case "dash":
          return 1.625 * value;
        case "tsp":
          return 0.202884136 * value;
        case "tbsp":
          return 0.0676280454 * value;
        case "fl oz":
          return 0.0338140227 * value;
        case "c":
          return 0.00422675284 * value;
        case "pt":
          return 0.00211337642 * value;
        case "qt":
          return 0.00105668821 * value;
        case "gal":
          return 0.000264172052 * value;
        default:
          return 0;
      }

    case "cl":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.01 * value;
        case "btl(s)":
          return 0.01 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value / 0.03125;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return 10 * value;
        case "dl":
          return 0.1 * value;
        case "l":
          return 0.01 * value;
        case "dash":
          return 16.25 * value;
        case "tsp":
          return 2.02884136 * value;
        case "tbsp":
          return 0.676280454 * value;
        case "fl oz":
          return 0.338140227 * value;
        case "c":
          return 0.0422675284 * value;
        case "pt":
          return 0.0211337642 * value;
        case "qt":
          return 0.0105668821 * value;
        case "gal":
          return 0.00264172052 * value;
        default:
          return 0;
      }

    case "dl":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.1 * value;
        case "btl(s)":
          return 0.1 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value / 0.003125;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return 100 * value;
        case "cl":
          return 10 * value;
        case "l":
          return 0.1 * value;
        case "dash":
          return 162.5 * value;
        case "tsp":
          return 20.2884136 * value;
        case "tbsp":
          return 6.76280454 * value;
        case "fl oz":
          return 3.38140227 * value;
        case "c":
          return 0.422675284 * value;
        case "pt":
          return 0.211337642 * value;
        case "qt":
          return 0.105668821 * value;
        case "gal":
          return 0.0264172052 * value;
        default:
          return 0;
      }

    case "l":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 1 * value;
        case "btl(s)":
          return 1 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value / 0.0003125;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return 1000 * value;
        case "cl":
          return 100 * value;
        case "dl":
          return 10 * value;
        case "dash":
          return 1625 * value;
        case "tsp":
          return 202.884136 * value;
        case "tbsp":
          return 67.6280454 * value;
        case "fl oz":
          return 33.8140227 * value;
        case "c":
          return 4.22675284 * value;
        case "pt":
          return 2.11337642 * value;
        case "qt":
          return 1.05668821 * value;
        case "gal":
          return 0.264172052 * value;
        default:
          return 0;
      }

    case "dash":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.001 * value;
        case "btl(s)":
          return 0.001 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value * 2;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return value / 1.625;
        case "cl":
          return value / 16.25;
        case "dl":
          return value / 162.5;
        case "l":
          return value / 1625;
        case "tsp":
          return value / 8;
        case "tbsp":
          return value / 24;
        case "fl oz":
          return value / 48;
        case "c":
          return value / 384;
        case "pt":
          return value / 768;
        case "qt":
          return value / 1536;
        case "gal":
          return value / 6144;
        default:
          return 0;
      }

    case "tsp":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.01 * value;
        case "btl(s)":
          return 0.01 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value * 16;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return value / 0.202884136;
        case "cl":
          return value / 2.02884136;
        case "dl":
          return value / 20.2884136;
        case "l":
          return value / 202.884136;
        case "dash":
          return value * 8;
        case "tbsp":
          return value / 3;
        case "fl oz":
          return value / 6;
        case "c":
          return value / 48;
        case "pt":
          return value / 96;
        case "qt":
          return value / 192;
        case "gal":
          return value / 768;
        default:
          return 0;
      }

    case "tbsp":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.01 * value;
        case "btl(s)":
          return 0.01 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value * 48;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return value / 0.0676280454;
        case "cl":
          return value / 0.676280454;
        case "dl":
          return value / 6.76280454;
        case "l":
          return value / 67.6280454;
        case "dash":
          return value * 24;
        case "tsp":
          return value * 3;
        case "fl oz":
          return value / 2;
        case "c":
          return value / 16;
        case "pt":
          return value / 32;
        case "qt":
          return value / 64;
        case "gal":
          return value / 256;
        default:
          return 0;
      }

    case "fl oz":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.03 * value;
        case "btl(s)":
          return 0.03 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value * 96;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return value / 0.0338140227;
        case "cl":
          return value / 0.338140227;
        case "dl":
          return value / 3.38140227;
        case "l":
          return value / 33.8140227;
        case "dash":
          return value * 48;
        case "tsp":
          return value * 6;
        case "tbsp":
          return value * 2;
        case "c":
          return value / 8;
        case "pt":
          return value / 16;
        case "qt":
          return value / 32;
        case "gal":
          return value / 128;
        default:
          return 0;
      }

    case "c":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.25 * value;
        case "btl(s)":
          return 0.25 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value * 768;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return value / 0.00422675284;
        case "cl":
          return value / 0.0422675284;
        case "dl":
          return value / 0.422675284;
        case "l":
          return value / 4.22675284;
        case "dash":
          return value * 384;
        case "tsp":
          return value * 48;
        case "tbsp":
          return value * 16;
        case "fl oz":
          return value * 8;
        case "pt":
          return value / 2;
        case "qt":
          return value / 4;
        case "gal":
          return value / 16;
        default:
          return 0;
      }

    case "pt":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 0.5 * value;
        case "btl(s)":
          return 0.5 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value * 1536;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return value / 0.00211337642;
        case "cl":
          return value / 0.0211337642;
        case "dl":
          return value / 0.211337642;
        case "l":
          return value / 2.11337642;
        case "dash":
          return value * 768;
        case "tsp":
          return value * 96;
        case "tbsp":
          return value * 32;
        case "fl oz":
          return value * 16;
        case "c":
          return value * 2;
        case "qt":
          return value / 2;
        case "gal":
          return value / 8;
        default:
          return 0;
      }

    case "qt":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 1 * value;
        case "btl(s)":
          return 1 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value * 3072;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return value / 0.00105668821;
        case "cl":
          return value / 0.0105668821;
        case "dl":
          return value / 0.105668821;
        case "l":
          return value / 1.05668821;
        case "dash":
          return value * 1536;
        case "tsp":
          return value * 192;
        case "tbsp":
          return value * 64;
        case "fl oz":
          return value * 32;
        case "c":
          return value * 4;
        case "pt":
          return value * 2;
        case "gal":
          return value / 4;
        default:
          return 0;
      }

    case "gal":
      switch (destUnit) {
        case "pc(s)":
          return 0;
        case "pkg(s)":
          return 4 * value;
        case "btl(s)":
          return 4 * value;
        case "g":
          return 0;
        case "kg":
          return 0;
        case "pinch":
          return value * 12288;
        case "oz":
          return 0;
        case "lb":
          return 0;
        case "ml":
          return value / 0.000264172052;
        case "cl":
          return value / 0.00264172052;
        case "dl":
          return value / 0.0264172052;
        case "l":
          return value / 0.264172052;
        case "dash":
          return value * 6144;
        case "tsp":
          return value * 768;
        case "tbsp":
          return value * 256;
        case "fl oz":
          return value * 128;
        case "c":
          return value * 16;
        case "pt":
          return value * 8;
        case "qt":
          return value * 4;
        default:
          return 0;
      }

    default:
      return 0;
  }
}
