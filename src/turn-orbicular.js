/**
*    CoTag Orbicular
*    A more or less pure CSS, circular, progress bar
*    
*   Copyright (c) 2014 CoTag Media.
*    
*    @author     Stephen von Takach <steve@cotag.me>
*    @copyright  2014 cotag.me
* 
*     
*     References:
*        * http://fromanegg.com/post/41302147556/100-pure-css-radial-progress-bar
*        * https://medium.com/@andsens/radial-progress-indicator-using-css-a917b80c43f9
*
**/

/**
 * Turn fork version of orbicular
 * 1. Add multiple circule support
 * 2. Add start rotation position configuration
 * 3. Add hoverover tooltip
 * 4. Add demo html
 */

// Initialize components
// Make sure every components only use at most one time
// to fit in 'angular way'.
var angular = window.angular || require('angular');

// Make sure turn/turnSlider library is not re-loading.
require('./template-build');

module.exports = angular
.module('turn/turnOrbicular', ['turnOrbicularTemplate'])
.value('turnOrbicularOptions', {

	// ...
	
})
.directive('turnOrbicular', ['$window', function (windowRef) {

    // Constants here reduce memory requirements of each circle
    var $window = angular.element(windowRef),

        // Cache event strings
        resizeEvents = 'orientationchange resize',

        // Set the rotation of the square
        updateProgress = function (circles, fix, pos) {
            circles.css({
                '-webkit-transform': 'rotate(' + pos + 'deg)',
                '-moz-transform': 'rotate(' + pos + 'deg)',
                '-ms-transform': 'rotate(' + pos + 'deg)',
                '-o-transform': 'rotate(' + pos + 'deg)',
                'transform': 'rotate(' + pos + 'deg)'
            });
            pos = pos * 2;
            fix.css({
                '-webkit-transform': 'rotate(' + pos + 'deg)',
                '-moz-transform': 'rotate(' + pos + 'deg)',
                '-ms-transform': 'rotate(' + pos + 'deg)',
                '-o-transform': 'rotate(' + pos + 'deg)',
                'transform': 'rotate(' + pos + 'deg)'
            });
        };

    return {
        templateUrl: 'turn-orbicular.html',
        transclude: true,
        replace: true,
        restrict: 'EA',
        scope: {
            current: '=progression',
            total: '='
        },
        link: function (scope, element, attrs) {
            var circles = [],
                fix,

                // Width must be an even number of pixels for the effect to work.
                setWidth = function () {
                    var width = element.prop('offsetWidth');
                    element.css('font-size', width - (width % 2) + 'px');
                };


            circles.push(element.children()[0]);
            circles.push(
                angular.element(
                    element.children()[0]
                ).children()[0]
            );
            circles.push(
                angular.element(
                    element.children()[1]
                ).children()[0]
            );
            circles = angular.element(circles);

            fix = angular.element(
                angular.element(
                    element.children()[1]
                ).children()[1]
            );
            console.log('fix', fix);

            // we have to use em's for the clip function to work like a percentage
            // so we have to manually perform the resize based on width
            setWidth();
            scope.$on('orb width', setWidth); // for programmatic resizing

            // Optionally resize
            if (attrs.hasOwnProperty('resize')) {
                scope.$on('$destroy', function () {
                    $window.off(resizeEvents, setWidth);
                });
                $window.on(resizeEvents, setWidth);
            }

            // we watch for changes to the progress indicator of the parent scope
            scope.$watch('current', function (newValue) {
                newValue = newValue / scope.total * 180.0;
                updateProgress(circles, fix, newValue);
            });

        }
    };
}]);
