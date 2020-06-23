#!/usr/bin/env python3
#
# Copyright (C) 2020 Jaume Orotlà <jaume.ortola@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
#

import sys, re
import xml.etree.ElementTree as ET

def XMLtoString(x):
    rough_string = ET.tostring(x, encoding="UTF-8", method="xml");
    return rough_string.decode("UTF-8")

def word(e):
    word = None
    # e.find("i") doesn't word. Bug?!
    for part in e:
        if part.tag == "i":
            word = part.text
    if word is None:
        p = e.find("p")
        if p:
            l = p.find("l")
            word = l.text
    if word is None:
        word = ""
    return word

source = sys.argv[1]
target = sys.argv[2]

tree = ET.ElementTree()
tree.parse(source)

pardefs = tree.find('pardefs')

prefixes = {}

for pardef in pardefs.iter(tag='pardef'):
    namepardef = pardef.get("n")
    if namepardef.startswith("prefixes_"):
        grammarclass = re.sub ("prefixes_([^_]+).*", "\\1", namepardef)
        prefixes[grammarclass]=namepardef

mainsection = tree.find('.//section[@id="main"]')

for e in mainsection.iter(tag='e'):
    par = e.find('par')
    if par is None:
        continue
    wordStr = word(e)
    if len(wordStr)<5 or '<b/>' in wordStr or '_' in wordStr:
        continue
    parname = par.get("n")
    for prefix in prefixes.keys():      
        if parname.endswith("__"+prefix):
            new = ET.Element('par')
            new.set('n', prefixes[prefix])
            e.insert(0, new)

tree.write(target)