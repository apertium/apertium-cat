#!/usr/bin/env python3
#
# Copyright (C) 2020 Jaume Ortolà <jaume.ortola@gmail.com>
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
        if p is not None:
            l = p.find("l")
            word = l.text
    if word is None:
        word = ""
    return word

def isMultiword(e):
    for part in e:
        if part.tag == "i":
            b = part.find("b")
            if b is not None:
                return True
    p = e.find("p")
    if p is not None:
        l=p.find("l")
        if l is not None:
            g = l.find("g")
            if g is not None:
                return True
            b = l.find("b")
            if b is not None:
                return True
        r=p.find("r")
        if r is not None:
            g = r.find("g")
            if g is not None:
                return True
            b = r.find("b")
            if b is not None:
                return True
    return False

source = sys.argv[1]
target = sys.argv[2]

tree = ET.ElementTree()
tree.parse(source)

pardefs = tree.find('pardefs')

prefixes = {}

for pardef in pardefs.iter(tag='pardef'):
    namepardef = pardef.get("n")
    if namepardef.startswith("prefixes_"):
        grammarclass = re.sub ("prefixes_([^_]+)$", "\\1", namepardef)
        prefixes[grammarclass]=namepardef

mainsection = tree.find('.//section[@id="main"]')

for e in mainsection.iter(tag='e'):
    if isMultiword(e):
        continue
    par = e.find('par')
    if par is None:
        p = e.find('p')
        if p is not None:
            par = p.find('r').find('s')
        if par is None:
            i = e.find('i')
            if i is not None:
                par = i.find('s')
        if par is None:
            continue
        parname = par.get("n")
        for prefix in prefixes.keys():
            if parname == prefix:
                new = ET.Element('par')
                prefixtoadd = prefixes[prefix]
                new.set('n', prefixtoadd)
                e.insert(0, new)
    parname = par.get("n")
    for prefix in prefixes.keys():
        if parname.endswith("__"+prefix):
            new = ET.Element('par')
            prefixtoadd = prefixes[prefix]
            new.set('n', prefixtoadd)
            e.insert(0, new)

tree.write(target)
