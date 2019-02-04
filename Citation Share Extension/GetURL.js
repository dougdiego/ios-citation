var GetURL = function() {};
GetURL.prototype = {
run: function(arguments) {

    /**
     * Get the selected text with HTML
     * Source: https://stackoverflow.com/questions/5222814/window-getselection-return-html
     */
    function getSelectionHtml() {
        var html = "";
        if (typeof window.getSelection != "undefined") {
            var sel = window.getSelection();
            if (sel.rangeCount) {
                var container = document.createElement("div");
                for (var i = 0, len = sel.rangeCount; i < len; ++i) {
                    container.appendChild(sel.getRangeAt(i).cloneContents());
                }
                html = container.innerHTML;
            }
        } else if (typeof document.selection != "undefined") {
            if (document.selection.type == "Text") {
                html = document.selection.createRange().htmlText;
            }
        }
        return html;
    }

    arguments.completionFunction({"URL": document.URL,
                                 "selection": window.getSelection().toString(),
                                 "selectionHtml": getSelectionHtml()
                                 });
}
};
var ExtensionPreprocessingJS = new GetURL;
