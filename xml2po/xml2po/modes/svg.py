# Copyright (c) 2004, 2005, 2006 Danilo Segan <danilo@gnome.org>.
#
# This file is part of xml2po.
#
# xml2po is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# xml2po is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with xml2po; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

# This implements special instructions for handling SVG picture files
# Mostly: if a text element node contains multiple tspan element nodes,
# merge the text of all tspan nodes before translation and explode them
# when merging back.
 
class svgXmlMode:
    """Class for special handling SVG picture files"""
    def getIgnoredTags(self):
        "Returns array of tags to be ignored."
        return ['itemizedlist', 'orderedlist', 'variablelist', 'varlistentry']

    def getFinalTags(self):
        "Returns array of tags to be considered 'final'."
        return ['para', 'title', 'releaseinfo', 'revnumber',
                'date', 'itemizedlist', 'orderedlist',
                'variablelist', 'varlistentry', 'term']

    def isFinalNode(self, node):
        #node.type =='text' or not node.children or
        if node.type == 'element' and node.name in self.getFinalTags():
            return True
        elif node.children:
            final_children = True
            child = node.children
            while child and final_children:
                if not child.isBlankNode() and child.type != 'comment' and not self.isFinalNode(child):
                    final_children = False
                child = child.next
            if final_children:
                return True
        return False

    def getSpacePreserveTags(self):
        "Returns array of tags in which spaces are to be preserved."
        return ['tspan']

    def getTreatedAttributes(self):
        "Returns array of tag attributes which content is to be translated"
        return []

    def _squashTspans(self,node,msg):
        first_node = None
        if node.type == 'element' and node.name == 'text':
            child = node.children
            if not child:
                ''' strange enough: a text element with no child'''
                return
            while not (child.type == 'element' and child.name == 'tspan'):
                child = child.next
                if not child:
                    return
            first_node = child
            first_node_string = first_node.content.strip()
            child = child.next
            while (child):
                if (child.type == 'element' and child.name == 'tspan'):
                    first_node_string += '\n' + child.content.strip()
                    child.setContent(" ")
                child = child.next
            first_node.setContent(first_node_string)
        elif node and node.children:
            child = node.children
            while child:
                self._squashTspans(child,msg)
                child = child.next
        
    def preProcessXml(self, doc, msg):
        "Preprocess a document and perhaps adds some messages."
        root = doc.getRootElement()
        self._squashTspans(root,msg)

    def _explodeTspans(self, node, language, translators):
        first_node = None
        if node.type == 'element' and node.name == 'text':
            child = node.children
            if not child:
                return
            while not (child.type == 'element' and child.name == 'tspan'):
                child = child.next
                if not child:
                    return
            first_node = child
            string_array = first_node.content.split('\n')
            first_node.setContent(string_array[0])
            i = 1
            child = child.next
            while (child):
                if (child.type == 'element' and child.name == 'tspan'):
                    child.setContent(string_array[i])
                    i+=1
                child = child.next
        elif node and node.children:
            child = node.children
            while child:
                self._explodeTspans(child, language, translators)
                child = child.next
        

    def postProcessXmlTranslation(self, doc, language, translators):
        """Sets a language and translators in "doc" tree.

        "translators" is a string consisted of translator credits.
        "language" is a simple string.
        "doc" is a libxml2.xmlDoc instance."""
        root = doc.getRootElement()
        self._explodeTspans(root, language, translators)
         
       

    def getStringForTranslators(self):
        """Returns None or a string to be added to PO files.

        Common example is 'translator-credits'."""
        return None

    def getCommentForTranslators(self):
        """Returns a comment to be added next to string for crediting translators.

        It should explain the format of the string provided by getStringForTranslators()."""
        return None
