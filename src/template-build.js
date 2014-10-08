angular.module('turnOrbicularTemplate', ['turn-orbicular.html']);

angular.module("turn-orbicular.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("turn-orbicular.html",
    "<div class=\"co-circle-progress\"> \n" +
    "    <div class=\"co-circle co-full\"> \n" +
    "        <div class=\"co-fill\"></div> \n" +
    "    </div> \n" +
    "    <div class=\"co-circle co-half\"> \n" +
    "        <div class=\"co-fill\"></div> \n" +
    "        <div class=\"co-fill co-fix\"></div> \n" +
    "    </div> \n" +
    "    \n" +
    "    <!-- Optional shadow -->\n" +
    "    <div class=\"co-shadow\"></div> \n" +
    "    <div class=\"co-content\"> \n" +
    "        <div><div> \n" +
    "            <div ng-transclude></div> \n" +
    "        </div></div> \n" +
    "    </div> \n" +
    "</div>");
}]);
