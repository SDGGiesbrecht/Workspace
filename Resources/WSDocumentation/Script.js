/*
 Script.js

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

function toggleLinkVisibility(link) {
    if (link.hasAttribute("style")) {
        link.removeAttribute("style");
    } else {
        link.style["padding-top"] = 0;
        link.style["padding-bottom"] = 0;
        link.style.height = 0;
    }
}

function toggleIndexSectionVisibility(sender) {
    var section = sender.parentElement;
    var links = section.children
    for (var linkIndex = 1; linkIndex < links.length; linkIndex++) {
        var link = links[linkIndex]
        toggleLinkVisibility(link)
    }
}

function contractIndex() {
    var indexElements = document.getElementsByClassName("index");
    var index = indexElements.item(indexElements.length - 1);
    var sections = index.children;
    for (var sectionIndex = 1; sectionIndex < sections.length; sectionIndex++) {
        var section = sections[sectionIndex]
        var links = section.children
        for (var linkIndex = 1; linkIndex < links.length; linkIndex++) {
            var link = links[linkIndex]
            toggleLinkVisibility(link)
        }
    }
}
