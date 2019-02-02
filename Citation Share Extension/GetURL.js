var GetURL = function() {};
GetURL.prototype = {
run: function(arguments) {
    arguments.completionFunction({"URL": document.URL, "selection": window.getSelection().toString() });
}
};
var ExtensionPreprocessingJS = new GetURL;
