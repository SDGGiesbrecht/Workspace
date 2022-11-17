/*

 */

function hideElement(element) {
    element.style["padding-top"] = 0;
    element.style["padding-bottom"] = 0;
    element.style.height = 0;
    element.style["overflow"] = "hidden";
}

function unhideElement(element) {
    element.removeAttribute("style");
}

function toggleLinkVisibility(link) {
    if (link.hasAttribute("style")) {
        unhideElement(link);
    } else {
        hideElement(link);
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

function contractIndex(currentSection) {
    var indexElements = document.getElementsByClassName("index");
    var index = indexElements.item(indexElements.length - 1);
    var sections = index.children;
    for (var sectionIndex = 1; sectionIndex < sections.length; sectionIndex++) {
        var section = sections[sectionIndex]
        if (section.getAttribute('id') != currentSection) {
            var links = section.children
            for (var linkIndex = 1; linkIndex < links.length; linkIndex++) {
                var link = links[linkIndex]
                toggleLinkVisibility(link)
            }
        }
    }
}

function showLanguageSwitch(sender) {
    var popup = document.getElementById("language‐switch");
    popup.style["display"] = "block";
}

function hideLanguageSwitch(sender) {
    var popup = document.getElementById("language‐switch");
    popup.style["display"] = "none";
}
