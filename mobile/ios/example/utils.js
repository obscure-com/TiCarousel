
exports.toHexString = function(r, g, b) {
  var sr = r.toString(16),
      sg = g.toString(16),
      sb = b.toString(16);
      
  sr = sr.length < 2 ? '0' + sr : sr;
  sg = sg.length < 2 ? '0' + sg : sg;
  sb = sb.length < 2 ? '0' + sb : sb;

  return String.format('#%s%s%s', sr, sg, sb);
}
