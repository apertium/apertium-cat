from xml.sax import handler, saxutils, make_parser
import sys

v_other = "other"

alternative = sys.argv[1]
dixfile     = sys.argv[2]

if alternative == "other":
  v_other = v_other[::-1] # reverse string

def printAttrs(attrsmap):
  if len(attrsmap) == 0:
    return ""
  output = []
  for (i,j) in attrsmap.items():
    output.append(i)
    output.append("=\"")
    output.append(saxutils.escape(j))
    output.append("\" ")
  
  return " " + "".join(output).strip()    

class DixHandler(handler.ContentHandler):
  def __init__(self, out = sys.stdout):
    handler.ContentHandler.__init__(self)
    self._out = out
    self._buf = []
    
  def flush(self):
    for i in self._buf:
      self._out.write(i.encode("utf-8"))
    self._buf = []
    
        
  def startElement(self, name, attrs):
    if name == "e" and "v" in attrs:
      attrs2 = {i:j for (i,j) in attrs.items() if i != "v"}
      vals = attrs["v"].split()
      if alternative in vals:
        attrs2["v"] = alternative
      else:
        attrs2["v"] = v_other
      attrs = attrs2
    self._buf.append("<" + name + printAttrs(attrs) + ">")
    
  def endElement(self, name):
    if len(self._buf) > 0 and self._buf[-1][0:1] == "<" and self._buf[-1][-1:] == ">" and self._buf[-1][1:2] != "/":
      self._buf[-1] = self._buf[-1][0:-1]+"/>"
      self.flush()
    else:
      self.flush()
      self._out.write("</")
      self._out.write(name)
      self._out.write(">")
  
  def characters(self, content):
    self.flush()
    self._out.write(saxutils.escape(content).encode("utf-8"))
        
parser = make_parser()
parser.setContentHandler(DixHandler())

with open(dixfile, "r") as f:
  parser.parse(f)
  