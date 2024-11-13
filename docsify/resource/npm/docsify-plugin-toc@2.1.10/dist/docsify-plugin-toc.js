(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["DocsifyPluginToc"] = factory();
	else
		root["DocsifyPluginToc"] = factory();
})(this, () => {
return /******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ 258:
/***/ ((__unused_webpack_module, exports) => {


Object.defineProperty(exports, "__esModule", ({ value: true }));
exports.install = exports.debounce = exports.setFluidClass = exports.scrollHandler = exports.generateToC = exports.pageToC = void 0;
// To collect headings and then add to the page ToC
function pageToC(headings, path) {
    var _a, _b;
    var toc = ['<div class="page_toc thin-scrollbar"><p class="has-text-weight-bold margin--bottom--sm">On this page</p>'];
    var list = [];
    var ignoreHeaders = ((_a = window.$docsify.toc) === null || _a === void 0 ? void 0 : _a.ignoreHeaders) || [];
    headings = document.querySelectorAll("#main ".concat(((_b = window.$docsify.toc) === null || _b === void 0 ? void 0 : _b.target) || "h2, h3, h4, h5, h6"));
    if (headings) {
        headings.forEach(function (heading) {
            var innerHtml = heading.innerHTML;
            var innerText = heading.innerText;
            var needSkip = false;
            if (ignoreHeaders.length > 0) {
                needSkip = ignoreHeaders.some(function (str) { return innerText.match(str); });
            }
            if (needSkip)
                return;
            var item = generateToC(parseInt(heading.tagName.replace(/h/gi, "")), innerHtml);
            if (item) {
                list.push(item);
            }
        });
    }
    if (list.length > 0) {
        toc = toc.concat(list);
        toc.push("</div>");
        return toc.join("");
    }
    else {
        return "";
    }
}
exports.pageToC = pageToC;
// To generate each ToC item
function generateToC(level, html) {
    var _a;
    if (level >= 1 && level <= (((_a = window.$docsify.toc) === null || _a === void 0 ? void 0 : _a.tocMaxLevel) || 5)) {
        var heading = ['<div class="lv' + level + ' is-size-8">', html, "</div>"].join("");
        return heading;
    }
    return "";
}
exports.generateToC = generateToC;
function scrollHandler() {
    var _a;
    // TOC
    var tocList = document.querySelectorAll(".page_toc > div");
    // Main
    var anchors = document.querySelectorAll("article#main " + ((window.$docsify.toc && window.$docsify.toc.target) || "h2, h3, h4, h5, h6"));
    var doc = document.documentElement;
    var coverHeight = ((_a = document.querySelector("section.cover")) === null || _a === void 0 ? void 0 : _a.getBoundingClientRect().height) || 0;
    var top = ((doc && doc.scrollTop) || document.body.scrollTop) - coverHeight;
    var last = null;
    for (var i = 0, len = anchors.length; i < len; i += 1) {
        var node = anchors[i];
        if ((node === null || node === void 0 ? void 0 : node.offsetTop) > top) {
            if (!last) {
                last = node;
            }
            break;
        }
        else {
            last = node;
        }
    }
    if (!last) {
        return;
    }
    tocList.forEach(function (toc) {
        var tocLink = toc.querySelector("a[data-id]");
        var tocLinkID = tocLink === null || tocLink === void 0 ? void 0 : tocLink.getAttribute("data-id");
        var isActive = tocLinkID === (last === null || last === void 0 ? void 0 : last.getAttribute("id"));
        toc.classList.toggle("active", isActive);
    });
}
exports.scrollHandler = scrollHandler;
function setFluidClass() {
    var contentContainer = document.querySelector(".content-container");
    var currentWindowWidth = window.innerWidth;
    // Call debounce to delay execution
    if (currentWindowWidth < 1700) {
        contentContainer === null || contentContainer === void 0 ? void 0 : contentContainer.classList.add("is-fluid");
    }
    else {
        contentContainer === null || contentContainer === void 0 ? void 0 : contentContainer.classList.remove("is-fluid");
    }
}
exports.setFluidClass = setFluidClass;
var debounce = function (func, delay) {
    if (delay === void 0) { delay = 500; }
    var timeoutId;
    return function () {
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
            args[_i] = arguments[_i];
        }
        var context = this;
        clearTimeout(timeoutId);
        timeoutId = setTimeout(function () {
            func.apply(context, args);
        }, delay);
    };
};
exports.debounce = debounce;
function install(hook, vm) {
    hook.mounted(function () {
        var content = window.Docsify.dom.find(".content");
        if (content) {
            var nav = window.Docsify.dom.create("aside", "");
            window.Docsify.dom.toggleClass(nav, "add", "toc-container");
            window.Docsify.dom.before(content, nav);
        }
    });
    hook.doneEach(function () {
        var nav = window.Docsify.dom.find(".toc-container");
        if (nav) {
            nav.innerHTML = pageToC().trim();
            if (nav.innerHTML === "") {
                window.Docsify.dom.toggleClass(nav, "add", "nothing");
                window.document.removeEventListener("scroll", scrollHandler);
            }
            else {
                window.Docsify.dom.toggleClass(nav, "remove", "nothing");
                scrollHandler();
                window.document.addEventListener("scroll", scrollHandler);
            }
        }
    });
    hook.ready(function () {
        // Parent elements
        var docMainContainer = document.querySelector(".content");
        // Child elements
        var tocContainer = document.querySelector(".toc-container");
        var markdownSection = document.querySelector(".markdown-section");
        // Check if it's doc portal by querying for els
        var isOnDocPortal = document.querySelector(".sgds-masthead") !== null;
        if (docMainContainer && tocContainer) {
            // Add classes for docMainContainer
            docMainContainer.classList.add("sgds-section", "is-flex", "is-flex-justify-c");
            // Create a new container element to hold the content and add classes
            var contentContainer = document.createElement("div");
            contentContainer.classList.add("content-container", "row", "w-100", "sgds-container", "is-flex", "is-flex-justify-c", "margin--right--none", "margin--left--none", "margin--top--sm", "padding--left", "padding--right"); // 'is-fluid'
            // Add classes for toc container
            tocContainer.classList.add("col", "col", "is-3-desktop", "is-3-widescreen", "is-3-fullhd", "is-hidden-touch", "padding--left", "padding--right");
            // Add class for markdown container
            markdownSection === null || markdownSection === void 0 ? void 0 : markdownSection.classList.add("col", "is-9", "is-12-touch");
            docMainContainer.setAttribute("style", "overflow-y: hidden;");
            if (isOnDocPortal) {
                contentContainer.classList.add("margin--top");
                docMainContainer.classList.add("margin--top--lg");
            }
            // Move all the child elements of tocContainer to contentContainer
            while (tocContainer.nextSibling) {
                contentContainer.appendChild(tocContainer.nextSibling);
            }
            // Insert contentContainer before tocContainer inside docMainContainer
            docMainContainer.insertBefore(contentContainer, tocContainer);
            // Move tocContainer to the top of contentContainer
            contentContainer.insertBefore(tocContainer, contentContainer.firstChild);
            setFluidClass();
            // Add a debouncer at the end
            window.addEventListener("resize", (0, exports.debounce)(setFluidClass, 100));
        }
    });
}
exports.install = install;


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be isolated against other modules in the chunk.
(() => {
var exports = __webpack_exports__;
var __webpack_unused_export__;

__webpack_unused_export__ = ({ value: true });
var toc_1 = __webpack_require__(258);
if (!window.$docsify) {
    window.$docsify = {};
}
window.$docsify.plugins = (window.$docsify.plugins || []).concat(toc_1.install);

})();

__webpack_exports__ = __webpack_exports__["default"];
/******/ 	return __webpack_exports__;
/******/ })()
;
});